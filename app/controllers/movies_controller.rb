class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    puts "======================================"
    # this is printed when we select a "more about [movie]"
    # this is executed when we actually go to "show more details about..."
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
#     params[] || sessions[] 
    # detect whether no params[] were passed that indicate sorting or filtering:
    # a way to tell that the user landing on the home page NOT having followed
    # one of the special links made in part 1 and part 2
    # if the user explicitly includes new sorting/filtering settings in params[]
    # the new values of those settings should then be saved 
    # There are very specific cases in which you should use the redirect, 
    # do not always redirect. Only redirect when you don't have parameters 
    # present in the URL but you do have session variables, so you can set
    # up your parameter variables using your session variables in that case

    # sessions is created kind of exactly like params
    
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    # we need this instance variable because index.html.erb must know
    # what checkboxes should be displayed
    puts "-abc-abca-abc-abca-b"
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
      # column selected for sorting should appear with a yellow-orange background
      # selected column header should have 2 additional CSS classes added
      # 1. hilite
      # 2. utility class from Bootstrap Colors
      # set controller variables that are used to conditionally set the CSS class
      
      if column == "Title"
        @movies = @movies.order(:title)
      else
        @movies = @movies.order(:release_date)
      end
    end 
#     @movies = Movie.with_ratings(@ratings_to_show)

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


#   def return_ratings_to_show
#     # controller must set up an empty-array value for @ratings_to_show even if 
#     # nothing is checked
#     # controller needs to know (i) how to figure out which boxes the user checked
#     # (ii) how to restrict the database query based on that result 
#   end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
    
end