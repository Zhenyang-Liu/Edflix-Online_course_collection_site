post "/submit-review/:id" do

  review = Review.new

  review.user_id = session[:user_id]
  review.course_id = params[:id]
  review.review_statement = params.fetch("content", "").strip
  review.updated_at = Sequel::CURRENT_TIMESTAMP

  review.save_changes

  redirect back

end

post "/add-rating/:id" do
  rating = Rating.new
  rating.user_id = session[:user_id]
  rating.course_id = params[:id]
  rating.rating_value = params[:rate]

  ratings = Rating.all

  ratings.each do |rate|
    if rate.user_id == rating.user_id and rate.course_id == rating.course_id
      rate.delete
    end
  end

  rating.save_changes

  redirect back
end




