class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    puts "======================================"
    puts params[:id]
    # this is executed when we actually go to "show more details about..."
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    # we need this instance variable because index.html.erb must know
    # what checkboxes should be displayed
    if params.has_key? (:ratings)
      @ratings_to_show = params[:ratings].keys.uniq
    else
      @ratings_to_show = []
    end
    # this is executed when the user checks some boxes and then hits refresh
#     @ratings_to_show = params[:rating].keys.unique
    # we now need this to check the box or not depending on what has been 
    # selected by the user
    # (i) how to figure out which boxes were checked by the user
    # (ii) how to restrict DB query based on that 
    @movies = Movie.with_ratings(@ratings_to_show)
    puts @movies
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

  def all_ratings
    Movie.all_ratings
  end

  def return_ratings_to_show
    # controller must set up an empty-array value for @ratings_to_show even if 
    # nothing is checked
    # controller needs to know (i) how to figure out which boxes the user checked
    # (ii) how to restrict the database query based on that result 
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
    
end