# moderator routes
get "/moderator-sign-in" do
  erb :"moderator/moderator_sign_in"
end

get "/moderator-sign-up" do
  erb :"moderator/moderator_sign_up"
end

get "/moderator-dashboard" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    redirect "/moderator-profile"
  else
    erb :sign_in
  end
end

get "/moderator-application" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    accountRequestDetails = AccountCreationRequest.load_request(@user.request_id)

    @accountRequestDetails = AccountCreationRequest[accountRequestDetails.request_id]

    @request_id = accountRequestDetails.request_id
    @company_name = accountRequestDetails.company_name
    @company_email = accountRequestDetails.company_email
    @account_type = accountRequestDetails.account_type
    @link = accountRequestDetails.link
    @supporting_document = accountRequestDetails.supporting_document
    @notes = accountRequestDetails.notes
    @status = accountRequestDetails.status
      
    erb :"moderator/moderator_application"
  else
   erb :sign_in
  end
end

post "/moderator-update-application" do
  @user = User.load_user(session[:email])
  
  accountRequestDetails = AccountCreationRequest.load_request(@user.request_id)
  @accountRequestDetails = AccountCreationRequest[accountRequestDetails.request_id]

  @request_id = accountRequestDetails.request_id
  @company_name = accountRequestDetails.company_name
  @company_email = accountRequestDetails.company_email
  @account_type = accountRequestDetails.account_type
  @link = accountRequestDetails.link
  @supporting_document = accountRequestDetails.supporting_document
  @notes = accountRequestDetails.notes
  @status = accountRequestDetails.status
      
  request_id = @user.request_id

  if !request_id.nil?
    @accountRequestDetails = AccountCreationRequest[request_id]
    @accountRequestDetails.load(params)

    if @accountRequestDetails.valid?
      @accountRequestDetails.save_changes
      user =User.find(username: @company_name)
      user.awaiting_approval_user
      redirect "/moderator-application"
    end
  end

  erb :"moderator/moderator_application"
end

get "/moderator-users-listing" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    if session[:managementUserSearchKeyword]
      @users = User.user_management_search(session[:managementUserSearchKeyword])
      puts @users
    else
      @users = User.load_all_users
    end
    erb :"moderator/moderator_users_listing"
  else
    erb :sign_in
  end
end

get "/user_listing_search_moderator" do
  keyword = params['managementUserSearchKeyword'] 
  @users = User.user_management_search(keyword)
  session[:managementUserSearchKeyword] = keyword
  redirect '/moderator-users-listing'
end

post "/clear_user_listing_search_moderator" do
  session.delete(:managementUserSearchKeyword)
  redirect '/moderator-users-listing'
end


get "/moderator-courses-pending-listing" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    if session[:pendingSearchKeyword]
      @courses = Courses_waiting_list.management_search(session[:pendingSearchKeyword])
    else
      @courses = Courses_waiting_list.load_all_courses
    end
    erb :"moderator/moderator_courses_pending_listing"
  else
    erb :sign_in
  end
end

get "/course_pending_search" do
    @user = User.load_user(session[:email])
    keyword = params['pendingSearchKeyword'] 
    @courses =Courses_waiting_list.management_search(keyword)
    session[:pendingSearchKeyword] = keyword
    redirect to('/moderator-courses-pending-listing')
end
  
post "/clear_pending_search" do
    session.delete(:pendingSearchKeyword)
    redirect '/moderator-courses-pending-listing'
end

post '/get_pending_course_data/:id' do
    @user = User.load_user(session[:email])
    @course = Courses_waiting_list.find(course_id: params[:id])
    @course.get_course_data(params)
end

post '/approve_pending_course/:id' do
    user = User.load_user(session[:email])
    id = user.user_id
    @course = Course.new
    @course.load(params, id)
    
  
    if @course.save
        @course = Courses_waiting_list.find(course_id: params[:id])
        if @course
            @course.delete_course
            flash[:success] = "Course successfully approved"
        else
            flash[:error] = "Pending course not found"
        end
        redirect '/moderator-courses-pending-listing'
    else
      "Error approving course"
    end
end

post '/delete_pending_course/:id' do
    @course = Courses_waiting_list.find(course_id: params[:id])
    if @course
      @course.delete_course
      flash[:success] = "Course deleted successfully"
    else
      flash[:error] = "Course not found"
    end
    redirect to('/moderator-courses-pending-listing')
end

get "/moderator-courses-listing" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    if session[:managementSearchKeyword]
      @courses = Course.management_search(session[:managementSearchKeyword])
    else
      @courses = Course.load_all_courses
    end
    erb :"moderator/moderator_courses_listing"
  else
    erb :sign_in
  end
end

get "/course_listing_search" do
  keyword = params['managementSearchKeyword'] 
  @courses = Course.management_search(keyword)
  session[:managementSearchKeyword] = keyword
  redirect to('/moderator-courses-listing')
end

post "/clear_listing_search" do
  session.delete(:managementSearchKeyword)
  redirect '/moderator-courses-listing'
end

post '/update_course/:id' do
    user = User.load_user(session[:email])
  if user
    @course = Course.find(course_id: params[:id])
    if @course
        @course.update_course(params, user.user_id)
        if params[:course_image] && params[:course_image][:tempfile]
            tempfile = params[:course_image][:tempfile]
            @course.save_image(tempfile, @course.course_id)
        end
        flash[:success] = "Course updated successfully"
    else
        flash[:error] = "Course not found"
    end
    redirect to('/moderator-courses-listing')
  else
    erb :sign_in
  end
end

post '/delete_course/:id' do
  @course = Course.find(course_id: params[:id])
  if @course
    @course.delete_course
    flash[:success] = "Course deleted successfully"
  else
    flash[:error] = "Course not found"
  end
  redirect to('/moderator-courses-listing')
end

post '/get_course_data/:id' do
  @course = Course.find(course_id: params[:id])
  @course.get_course_data(params)
end

get "/moderator-notification" do
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    erb :"moderator/moderator_notification"
  else
    erb :sign_in
  end
end

get "/moderator-users-messaging" do
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    erb :"moderator/moderator_users_messaging"
  else
    erb :sign_in
  end
end

get "/moderator-support" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    erb :"moderator/moderator_support"
  else
    erb :sign_in
  end
end

get "/moderator-add-course" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    erb :"moderator/moderator_add_course"
  else
    erb :sign_in
  end
end

post '/add_course' do
      user = User.load_user(session[:email])
    if user
        course = Course.new
        course.load(params, user.user_id)

        if course.save
            if params[:course_image] && params[:course_image][:tempfile]
                tempfile = params[:course_image][:tempfile]
                course.save_image(tempfile, course.course_id)
            end

            flash[:success] = "Course successfully added"
            redirect '/moderator-add-course'
        else
            "Error saving course"
        end
    else
        erb :sign_in
    end
end

get "/moderator-update-course" do
  erb :"moderator/moderator_update_course"
end

get "/moderator-send-message" do
  @user = User.load_user(session[:email])
  @broadcast = Broadcast.new
  erb :"moderator/moderator_send_message"
end

post "/moderator-send-message" do
  @broadcast = Broadcast.new
  @broadcast.load(params)

  if @broadcast.valid?
    @broadcast.save_changes
    redirect "/moderator-send-message"
  end

  erb :"moderator/moderator_send_message"
end
