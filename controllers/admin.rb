# administrator routes

require 'sequel'
get "/administrator-sign-in" do
  erb :"administrator/administrator_sign_in"
end
  
get "/administrator-dashboard" do
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9 
    redirect "/administrator-profile"
  else
    erb :sign_in
  end
end

get "/administrator-account-reset-request-listing" do
  @user =   @user = User.load_user(session[:email])
  @requests = User.filter_users(params[:filter_criteria])
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    if session[:managementUserSearchKeyword]
      @requests = User.user_management_search(session[:managementUserSearchKeyword])
    else
      @requests = AccountResetRequest.load_all_account_reset_request
    end
    erb :"administrator/administrator_account_reset_request_listing"
  else
    erb :sign_in
  end
end

post "/reset-account/:id" do
  request = AccountResetRequest.find(request_id: params[:id])
  request.reset_account

  user = User.find(username: request.username)

  if user != nil
    user.reset_password
  end
  redirect '/administrator-account-reset-request-listing'
end

get "/administrator-notification" do
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    erb :"administrator/administrator_notification"
  else
    erb :sign_in
  end
end

get "/administrator-users-listing" do
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    if session[:managementUserSearchKeyword]
      @users = User.user_management_search(session[:managementUserSearchKeyword])
    else
      @users = User.load_all_users
    end
    erb :"administrator/administrator_users_listing"
  else
    erb :sign_in
  end
end

get "/user_listing_search" do
  keyword = params['managementUserSearchKeyword'] 
  @users = User.user_management_search(keyword)
  session[:managementUserSearchKeyword] = keyword
  redirect '/administrator-users-listing'
end

post "/clear_user_listing_search" do
  session.delete(:managementUserSearchKeyword)
  redirect '/administrator-users-listing'
end

post "/suspend_user/:id" do
  user = User.find(user_id: params[:id])
  user.suspend_user
  redirect '/administrator-users-listing'
end

post "/unsuspend_user/:id" do
  user = User.find(user_id: params[:id])
  user.unsuspend_user
  redirect '/administrator-users-listing'
end

get "/administrator-add-new-authority" do
  @user = User.load_user(session[:email])
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    erb :"administrator/administrator_add_new_authority"
  else
   erb :sign_in
  end
end

get "/administrator-courses-listing" do
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    if session[:managementSearchKeyword]
      @courses = Course.management_search(session[:managementSearchKeyword])
    else
      @courses = Course.load_all_courses
    end
    erb :"administrator/administrator_courses_listing"
  else
    erb :sign_in
  end
end

get "/administrator_course_listing_search" do
  keyword = params['managementSearchKeyword'] 
  @courses = Course.management_search(keyword)
  session[:managementSearchKeyword] = keyword
  redirect to('/administrator-courses-listing')
end

post "/administrator_clear_listing_search" do
  session.delete(:managementSearchKeyword)
  redirect '/administrator-courses-listing'
end

get "/administrator-course-view" do
  erb :"administrator/administrator_view_course"
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    erb :"administrator/administrator_view_course"
  else
    erb :sign_in
  end
end

get "/administrator-messages" do
  @username_search = params.fetch("username_search", "").strip

  @contact_forms = if @username_search.empty?
               Contact_form.all
             else
               Contact_form.where(Sequel.like(:username, "%#{@username_search}%"))
             end
  erb :"administrator/administrator_messages"
end