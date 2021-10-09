class MoviesController < ApplicationController

  def show # show more details about...
    id = params[:id] || session[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings # tell index.html.erb which boxes to show
    
    if not params.has_key? (:ratings) and not params.has_key? (:column)
      if session.has_key? (:ratings)
        redirect_to movies_path(:ratings => session[:ratings])
#         params[:ratings] = session[:ratings]
      else # params has no :ratings AND session has no :ratings
      end
      if session.has_key? (:column)
        redirect_to movies_path(:column =>session[:column])
#         params[:column] = session[:column]
      end
    end
    
# redirect_to(movies_path(:sort_by => sort_by, :ratings => Hash[@ratings_to_show.map {|rating| [rating, '1']}]))
# redirect_to movies_path(:sort=> session[:sort], :ratings => session[:ratings])
    
    if params.has_key? (:ratings)
      session[:ratings] = params[:ratings] # added
      @ratings_to_show = params[:ratings].keys.uniq
    else
#       @ratings_to_show = []
      @ratings_to_show = @all_ratings
    end

    @movies = Movie.with_ratings(@ratings_to_show)
    
    if params.has_key? (:column) # to indicate the column we sort on
      column = params[:column] 
      session[:column] = params[:column] # added
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