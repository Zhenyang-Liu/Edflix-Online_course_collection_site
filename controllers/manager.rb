# manager routes
require 'sequel'

get "/manager-sign-in" do
    erb :"manager/manager_sign_in"
  end
  
  get "/manager-dashboard" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
      redirect "/manager-profile"
    else
      erb :sign_in
    end
  end
  
  get "/manager-notification" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
      erb :"manager/manager_notification"
    else
      erb :sign_in
    end
  end

  # manager user listing

  get "/manager-users-listing" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
      if session[:managementUserSearchKeyword]
        @users = User.user_management_search(session[:managementUserSearchKeyword])
        puts @users
      else
        @users = User.load_all_users
      end
      erb :"manager/manager_users_listing"
    else
      erb :sign_in
    end
  end

  get "/user_listing_search_manager" do
    keyword = params['managementUserSearchKeyword'] 
    @users = User.user_management_search(keyword)
    session[:managementUserSearchKeyword] = keyword
    redirect '/manager-users-listing'
  end
  
  post "/clear_user_listing_search_manager" do
    session.delete(:managementUserSearchKeyword)
    redirect '/manager-users-listing'
  end

  post "/user_listing_filter_manager" do
    @users = User.filter_users(params[:filter_criteria])
    @user_filter = params[:filter_criteria]
    erb :"manager/manager_users_listing"
  end

  # account request listing

  get "/manager-account-request-listing" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
    if session[:accountRequestSearchKeyword]
        @requests = AccountCreationRequest.manager_account_request_search(session[:accountRequestSearchKeyword])
    else
        @requests = AccountCreationRequest.load_all_request
    end
    erb :"manager/manager_account_request_listing"
    else
    erb :sign_in
    end
  end

  get "/account_request_search_manager" do
    keyword = params['accountRequestSearchKeyword'] 
    @users = AccountCreationRequest.manager_account_request_search(keyword)
    session[:accountRequestSearchKeyword] = keyword
    redirect '/manager-account-request-listing'
  end

  post "/clear_account_request_search_manager" do
    session.delete(:accountRequestSearchKeyword)
    redirect '/manager-account-request-listing'
  end

  get "/manager-account-request-detail" do
    @accountRequestDetails = AccountCreationRequest.find(request_id: params[:id])
    erb :"manager/manager_account_request_detail"
  end

  post "/approve-request" do
    request = AccountCreationRequest.find(request_id: params[:id])
    request.approve_request
    user = AccountCreationRequest.load_request(params[:id])
    user = User.load_user(user.company_name)
    if user != nil
      user = User.find(user_id: user.user_id)
      user.unsuspend_user
    end 

    redirect '/manager-account-request-listing'
  end

  post "/reject-request" do
    request = AccountCreationRequest.find(request_id: params[:id])
    request.reject_request
    user = AccountCreationRequest.load_request(params[:id])
    user = User.load_user(user.company_name)
    if user != nil
      user = User.find(user_id: user.user_id)
      user.suspend_user
    end 
    redirect '/manager-account-request-listing'
  end

  # course listing

  get "/manager-courses-listing" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
      if session[:managementSearchKeyword]
        @courses = Course.management_search(session[:managementSearchKeyword])
      else
        @courses = Course.load_all_courses
      end
      erb :"manager/manager_courses_listing"
    else
      erb :sign_in
    end
  end
  
  get "/manager_course_listing_search" do
    keyword = params['managementSearchKeyword'] 
    @courses = Course.management_search(keyword)
    session[:managementSearchKeyword] = keyword
    redirect to('/manager-courses-listing')
  end
  
  post "/manager_clear_listing_search" do
    session.delete(:managementSearchKeyword)
    redirect '/manager-courses-listing'
  end

  get "/manager-course-view" do
    if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
      erb :"manager/manager_view_course"
    else
      erb :sign_in
    end
  end
