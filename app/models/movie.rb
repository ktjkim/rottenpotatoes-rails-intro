class Movie < ActiveRecord::Base
  # create class method of Movie that returns an appropriate value
  # i.e. enumerable collection of all possible values of a movie rating
  # this value could be Movie.all_ratings
  # controller should assign that to the appropriate instance variable

  # we need self because we need an instance of Movie to select all ratings 
  def self.all_ratings
    # https://apidock.com/rails/v2.3.8/ActiveRecord/Base/find/class
    @all_ratings = Movie.select(:rating).map(&:rating).uniq
    puts @all_ratings
    return @all_ratings
  end
  
  # ratings_list here is the list of movies checked by the user (may be nil)
  def self.with_ratings(ratings_list)
    if ratings_list == []
      Movie.all # retrieve ALL movies
    else
      puts '----a-a--a-a-a-a-a-a'
      puts ratings_list
      Movie.where(:all, :conditions => {:rating =>ratings_list})
      # how do I determine the correct return type 
      # Movie.select returns a hash
      # Movie.where returns a Symbol
    end
  end

end
