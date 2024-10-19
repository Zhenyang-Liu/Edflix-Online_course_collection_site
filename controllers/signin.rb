get "/sign-in" do
  if session[:logged_in]
    case session[:account_type]
    when "1"
      redirect "/user-dashboard"
    when "2"
      redirect "/moderator-dashboard"
    when "3"
      redirect "/manager-dashboard"
    when "4"
      redirect "/administrator-dashboard"
    when "5"
      redirect "/course-provider-dashboard"
    when "6"
      redirect "/course-provider-dashboard"
    when "7"
      redirect "/moderator-dashboard"
    when "8"
      redirect "/manager-dashboard"
    when "9"
      redirect "/administrator-dashboard"
    else
      redirect "/user-dashboard"
    end
  end
  erb :sign_in
end

post "/sign-in" do
  user = User.load_user(params["email"])

  if  user != nil && user.is_suspended == 1 && user.account_type == "1"
    @error = "Your account has been suspended, please contact us for details."
    erb :sign_in
  elsif user && user.authenticate(params["password"])
    session[:logged_in] = true
    session[:username] = user.username
    session[:email] = user.email
    session[:account_type] = user.account_type
    session[:user_id] = user.user_id

    case user.account_type
    when "1"
      redirect "/user-dashboard"
    when "2"
      redirect "/moderator-dashboard"
    when "3"
      redirect "/manager-dashboard"
    when "4"
      redirect "/administrator-dashboard"
    when "5"
      redirect "/course-provider-dashboard"
    when "6"
      redirect "/course-provider-dashboard"
    when "7"
      redirect "/moderator-dashboard"
    when "8"
      redirect "/manager-dashboard"
    when "9"
      redirect "/administrator-dashboard"
    else
      redirect "/user-dashboard"
    end
  elsif user == nil
    @error = "The account is not existed. Please sign up."
    erb :sign_in
  elsif user.password == "reset"
    @error = "Your password was reset."
    session[:temp_username] = user.username
    erb :sign_in
  else
    @error = "Username/Password combination incorrect"
    erb :sign_in
  end
end

get "/password-reset" do
  erb :password_reset
end

post "/assign-new-password" do
  user = User.find(username: session[:temp_username])
  user.assign_new_password(params)
  flash[:success] = "Password updated successfully"
  case user.account_type
  when "1"
    redirect "/user-dashboard"
  when "2"
    redirect "/moderator-dashboard"
  when "3"
    redirect "/manager-dashboard"
  when "4"
    redirect "/administrator-dashboard"
  when "5"
    redirect "/course-provider-dashboard"
  when "6"
    redirect "/course-provider-dashboard"
  when "7"
    redirect "/moderator-dashboard"
  when "8"
    redirect "/manager-dashboard"
  when "9"
    redirect "/administrator-dashboard"
  else
    redirect "/user-dashboard"
  end
  erb :sign_in
end

post '/new_password_reset_request_email' do
    # Extract username and email from params
    usernameOrEmail = params.fetch("usernameOrEmail", "").strip

    if  !usernameOrEmail.empty? 
        # Generate query criteria based on input
        query_conditions = { username: usernameOrEmail, email: usernameOrEmail }

        # Find a user, based on username or email
        user = User.first(Sequel.or(query_conditions)) if query_conditions.any?
        if user
            if user.email != nil
                password_reset = user.generate_password_reset_token
                host = request.scheme + "://" + request.host_with_port

                # Send an email with a link to reset your password
                reset_password_url = "#{host}/reset_password/#{password_reset.password_reset_token}"
                send_email(
                  user.email,
                  'Password reset request',
                  "Please click on the following link to reset your password：\n\n#{reset_password_url}\n\n This link will expire in 1 hour."
                )
            
                flash[:success] = "A password reset link has been sent to #{user.email}, please check your email."
                redirect to('/account-reset-request-email')
            else
                flash[:alert] = 'The account associated with this email address could not be found.'
                erb :account_reset_request_email
            end
        else
            flash.now[:alert] = " The user does not exist, please check the relevant information."
            erb :account_reset_request_email
        end
    else
        flash.now[:error] = "username and email cannot be both empty"
        erb :account_reset_request_email
    end 
end

get '/reset_password/:token' do
    @password_reset = PasswordReset.first(password_reset_token: params[:token])

    if @password_reset && @password_reset.password_reset_token_expires_at > Time.now
        erb :password_reset_email
    else
        flash[:alert] = 'The password reset link has expired or is invalid. Please resend your password reset request.'
        redirect to('/account-reset-request-email')
    end
end

patch '/reset_password/:token' do
    @password_reset = PasswordReset.first(password_reset_token: params[:token])

    if @password_reset && @password_reset.password_reset_token_expires_at > Time.now
        @user = @password_reset.user

        if @user.assign_new_password_email(params)
            @password_reset.destroy
            flash[:notice] = 'Password has been successfully reset. Please login with your new password.'
            redirect to('/sign-in')
        else
            flash[:alert] = 'The password could not be updated, please check your input.'
            redirect back
        end
    else
        flash[:alert] = 'The password reset link has expired or is invalid. Please resend your password reset request.'
        redirect to('/account-reset-request-email')
    end
end