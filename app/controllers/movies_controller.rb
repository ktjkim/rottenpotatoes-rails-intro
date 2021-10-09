class MoviesController < ApplicationController

  def show # show more details about...
    id = params[:id] || session[:id] # retrieve movie ID from URI route
    puts "=====show====="
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # There are very specific cases in which you should use the redirect, 
    # do not always redirect. Only redirect when you don't have parameters 
    # present in the URL but you do have session variables, so you can set
    # up your parameter variables using your session variables in that case
    
    @movies = Movie.all
    @all_ratings = Movie.all_ratings # tell index.html.erb which boxes to show
    puts "-----index-----"
    puts params
    if params.has_key? (:ratings)
      @ratings_to_show = params[:ratings].keys.uniq
    else
      @ratings_to_show = []
    end

    @movies = Movie.with_ratings(@ratings_to_show)
    
    if params.has_key? (:column) # to indicate the column we sort on
      column = params[:column]
      
      @selection_criterion = params[:column]
      if column == "Title"
        @movies = @movies.order(:title)
      else
        @movies = @movies.order(:release_date)
      end
      
    end 
    @movies
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
    
end