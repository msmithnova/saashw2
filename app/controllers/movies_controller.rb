class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort]
    @all_ratings = Movie.ratings
    @ratings = params[:ratings]
    redirect = false
    if @sort_by.nil? && !session[:sort].nil?
      @sort_by = session[:sort]
      redirect = true
    end
    if @ratings.nil? && !session[:ratings].nil?
      @ratings = session[:ratings]
      redirect = true
    end
    if redirect
      flash.keep
      redirect_to movies_path(:sort => @sort_by, :ratings => @ratings)
    end
    if @ratings.nil?
      @ratings = Hash.new
      @all_ratings.each {|rating| @ratings[rating] = 1}
    end
    if @sort_by.nil?
      @movies = Movie.find_all_by_rating(@ratings.keys)
    else
      @movies = Movie.find_all_by_rating(@ratings.keys, :order => "#{@sort_by} ASC")
    end
    session[:sort] = @sort_by
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
