get "/sign-up" do
  redirect "/user-profile" if session[:logged_in]
  erb :sign_up
end

get "/sign-up-admin" do
  erb :sign_up_admin
end

post '/sign-up' do
  @user = User.new
  @user.signup(params)

  if @user.valid? && @user.save
    session.clear
    user = User.load_user(params["email"])
    session[:logged_in] = true
    session[:account_type] = user.account_type
    session[:user_id] = user.user_id
    session[:username] = user.username
    session[:email] = user.email

    if session[:account_type] == "2"
      redirect '/moderator-dashboard'
    elsif session[:account_type] == "4"
        redirect '/administrator-dashboard'
    elsif session[:account_type] == "5"
      redirect '/course-provider-dashboard'
    elsif session[:account_type] == "6"
      redirect '/course-provider-add-contributor'
    else
      flash.now[:notice] = "Please update your profile details"
      redirect '/user-profile'
    end
  else
    flash.now[:error] = @user.errors.full_messages
    if session[:temp_account_type] == "2" || session[:temp_account_type] == "5"
      erb :account_request_success
    else
      erb :sign_up
    end
  end
end

post '/sign-up-admin' do
  @user = User.new
  @user.signup(params)

  if @user.valid? && @user.save
    session.clear
    user = User.load_user(params["username"])
    session[:logged_in] = true
    session[:account_type] = user.account_type
    session[:user_id] = user.user_id
    session[:username] = user.username

    if session[:account_type] == "2"
      redirect '/moderator-dashboard'
    elsif session[:account_type] == "5"
      redirect '/course-provider-dashboard'
    elsif session[:account_type] == "6"
      redirect '/course-provider-add-contributor'
    else
      flash.now[:notice] = "Please update your profile details"
      redirect '/user-profile'
    end
  else
    flash.now[:error] = @user.errors.full_messages
    if session[:temp_account_type] == "2" || session[:temp_account_type] == "5"
      erb :account_request_success
    else
      erb :sign_up
    end
  end
end

post '/sign-up-contributor' do
  @user = User.new
  @user.signup(params)

  if @user.valid? && @user.save
    redirect '/course-provider-add-contributor'
  else
    flash.now[:error] = @user.errors.full_messages
    if session[:temp_account_type] == "2" || session[:temp_account_type] == "5"
      erb :account_request_success
    else
      erb :sign_up
    end
  end
end

post '/sign-up-authority' do
  @user = User.new
  @user.signup(params)

  if @user.valid? && @user.save
    redirect "/administrator-users-listing"
  else
    flash.now[:error] = @user.errors.full_messages
    if session[:account_type] == "4"
      erb :"administrator/administrator_courses_listing"
    else
      erb :sign_up
    end
  end
end