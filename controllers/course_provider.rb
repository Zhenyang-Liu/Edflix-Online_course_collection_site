# course_provider routes

get "/course-provider-dashboard" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
    erb :"course_provider/course_provider_dashboard"
  else
    erb :sign_in
  end
end

get "/course-provider-contributor-listing" do
  @user = User.load_user(session[:email])
  @users = User.filter_users(params[:filter_criteria])
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
    if session[:managementUserSearchKeyword]
      @users = User.user_management_search(session[:managementUserSearchKeyword])
    else
      @users = User.load_contributor(@user.company)
    end
    erb :"course_provider/course_provider_contributor_listing"
  else
    erb :sign_in
  end
end

get "/course-provider-add-contributor" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
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
      
    erb :"course_provider/course_provider_add_contributor"
  else
   erb :sign_in
  end
end


get "/course-provider-courses-listing" do
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
    @user = User.load_user(session[:email])
    if session[:managementSearchKeyword_cp]
      courses = Course.management_search(session[:managementSearchKeyword_cp])
      @courses = Course.company_search(courses, @user.company)
    else
      @courses = Course.company_search(Course.all, @user.company)
    end
    erb :"course_provider/course_provider_courses_listing"
  else
    erb :sign_in
  end
end

get "/course_listing_search_course_provider" do
    user = User.load_user(session[:email])
  if user
    keyword = params['managementSearchKeyword_cp'] 
    course = Course.management_search(keyword)
    @courses = Course.company_search(course, user.company)
    session[:managementSearchKeyword_cp] = keyword
    redirect to('/course-provider-courses-listing')
  else
    erb :sign_in
  end
end

post "/clear_listing_search_course_provider" do
  session.delete(:managementSearchKeyword_cp)
  redirect '/course-provider-courses-listing'
end

post '/course-provider-update_course/:id' do
    user = User.load_user(session[:email])
  if user
    @course = Course.find(course_id: params[:id])
    if @course
        @course.update_course(params, user.user_id)
        if params[:course_image] && params[:course_image][:tempfile]
            tempfile = params[:course_image][:tempfile]
            course.save_image(tempfile, course.course_id)
        end
        flash[:success] = "Course updated successfully"
    else
        flash[:error] = "Course not found"
    end
    redirect to('/course-provider-courses-listing')
  else
    erb :sign_in
  end
end

get "/course-provider-add-new-course" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
    erb :"course_provider/course_provider_add_course"
  else
    erb :sign_in
  end
end

post '/course-provider-add_course' do
    user = User.load_user(session[:email])
  if user
      @course = Course.new
      @course.load(params, user.user_id, user.account_type)

      if @course.save
            if params[:course_image] && params[:course_image][:tempfile]
               tempfile = params[:course_image][:tempfile]
               course.save_image(tempfile, course.course_id)
            end
          flash[:success] = "Course successfully added"
          redirect '/course-provider-add-new-course'
      else
          "Error saving course"
      end
  else
      erb :sign_in
  end
end

get "/course-provider-application" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 5 || session[:account_type].to_i == 6
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
      
    erb :"course_provider/course_provider_application"
  else
   erb :sign_in
  end
end

post "/course-provider-update-application" do
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
      redirect "/course-provider-application"
    end
  end

  erb :"course_provider/course_provider_application"
end