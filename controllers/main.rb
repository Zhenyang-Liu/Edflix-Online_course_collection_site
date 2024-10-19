# main routes
get "/" do
  erb :welcome
end
  
get "/explore" do
  if session[:user_id]
   @enrollments = Enrollment.where(user_id: session[:user_id])
  else
   @enrollments = []
  end

  if session[:courseSearchKeyword]
    @courses = Course.search(session[:courseSearchKeyword])
  else
    @courses = Course.load_available_courses
  end

  erb :explore
end

get "/course_search" do
  if session[:user_id]
    @enrollments = Enrollment.where(user_id: session[:user_id])
  end
  # Get search keywords from the form 
  keyword = params['courseSearchKeyword'] 

  # Call the load_search_results method to get the search results
  @courses = Course.search(keyword)

  # Save the search keyword to the session
  session[:courseSearchKeyword] = keyword

  # Render the page showing the results
  redirect '/explore'
end

post "/clear_search" do
    if session[:user_id]
      @enrollments = Enrollment.where(user_id: session[:user_id])
    end
    session.delete(:courseSearchKeyword)
    redirect '/explore'
end

get "/recommendations—for-major" do
      user = User.load_user(session[:email])
    if user
        filter = user.academic_major
        sort = "Default"
        @courses = Course.filtered_and_sorted(filter, sort)
        if session[:user_id]
            @enrollments = Enrollment.where(user_id: session[:user_id])
        else
            @enrollments = []
        end
        erb :explore
    else
        erb :sign_in
    end
end

get "/select_courses" do
    filter = params[:filter]
    sort = params[:sort]
    @selectedSort = sort
    @selectedFilter = filter

    if session[:courseSearchKeyword]
        results = Course.search(session[:courseSearchKeyword])
        results_ids = results.map(&:course_id)
        results_dataset = Course.where(course_id: results_ids)
        @courses = Course.filtered_and_sorted(filter, sort, results_dataset)
    else
        @courses = Course.filtered_and_sorted(filter, sort)
    end

    if session[:user_id]
        @enrollments = Enrollment.where(user_id: session[:user_id])
    else
        @enrollments = []
    end

    erb :explore
end


post '/recommendations-ai' do
    if session[:user_id]
        @enrollments = Enrollment.where(user_id: session[:user_id])
       else
        @enrollments = []
    end

    api_key = 'xxxxxx' # Replace with your OpenAI API key
    openai = OpenAI.new(api_key)
    
    # Get user input
    user_input = params['user_input']
  
    # Get the list of courses
    course_list = Course.load_available_courses.map { |course| { id: course.course_id, name: course.course_name} }
  
    # Get course recommendations
    results = openai.get_course_recommendations(user_input, course_list)
    if results.is_a?(String)
        @accident = results
        @courses = Course.load_available_courses
    else
        @courses, @reasons = results[0], results[1]
    end
    
    erb :explore
end


get "/course_detail/:id" do
  if session[:user_id]
    @reviews = Review.all
    @enrollments = Enrollment.where(user_id: session[:user_id])
    @wishlists = Wishlist.where(user_id: session[:user_id])
  else
    @enrollments = []
    @wishlists = []
  end
  
  @course = Course.find(course_id: params[:id])
  if @course
    @num_enrollments = @course .num_enrollments
  else
    @num_enrollments = 0
  end

  @all_rating = Rating.all
  @rating_counts = Rating.where(course_id: params[:id])
  @rating_count = @rating_counts.count

  @sum = 0

  @rating_counts.each do |ratingV|
    @sum += ratingV.rating_value
  end


  if @sum != 0
    @average = @sum/@rating_count.to_f
  else
    @average = 0.0
  end
  
  @allUsers = User.all
  @reviews = Review.all

  erb :course_detail
end

get "/switch-account-to-user" do
  if session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    erb :"user/user_dashboard"
  else
    erb :sign_in
  end
end

get "/switch-account-to-authority" do
  if session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    if session[:account_type] == "7"
      erb :"moderator/moderator_dashboard"
    elsif session[:account_type] == "8"
      erb :"manager/manager_dashboard"
    elsif session[:account_type] == "9"
      erb :"administrator/administrator_dashboard"
    end
  else
    erb :sign_in
  end
end