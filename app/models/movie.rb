class Movie < ActiveRecord::Base
  # create class method of Movie that returns an appropriate value
  # i.e. enumerable collection of all possible values of a movie rating
  # this value could be Movie.all_ratings
  # controller should assign that to the appropriate instance variable

  # self would be an instance method
  def self.all_ratings
    # https://apidock.com/rails/v2.3.8/ActiveRecord/Base/find/class
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    puts @all_ratings
    return @all_ratings
    # record query interface 
    # controller must assign this value @all_ratings to the appropriate 
    # instance variable  
  end

  def self.with_ratings(ratings_list)
    if ratings_list == nil
      Movie.find(:all) # retrieve ALL movies
    else
      Movie.find(:all, :conditions => {:rating => ratings_list})
      # ratings_list is an array such as ['G', 'PG', 'R'] -- 
      # retrieve ALL movies with those ratings 
      # :rating => ratings_list or params[:rating] => ratings_list?
    end
  end

end
