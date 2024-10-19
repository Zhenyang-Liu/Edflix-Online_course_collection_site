class Review < Sequel::Model

end


class Rating < Sequel::Model
    # Calculate average rating based on course ID
    def self.calculate_average_rating(course_id)
        # Define a variable to store the total rating
        total_rating = 0
    
        # Use course ID to find rating records
        rating_count = 0
    
        # Use course ID to find rating records
        ratings = self.where(course_id: course_id)
    
        # Iterate through the rating records, add up the total ratings and count the number of ratings
        ratings.each do |rating|
        total_rating += rating.rating_value
        rating_count += 1
        end
    
        # Calculate the average rating to ensure it does not divide by zero
        if rating_count > 0
          average_rating = total_rating.to_f / rating_count
        else
          average_rating = 0
        end
    
        # Use the round method to retain one decimal place
        average_rating.round(1)
    end
end
      
