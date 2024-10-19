get "/user-profile" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    user = User.load_user(session[:email])
  
    @user = User[user.user_id]

    @user_id = user.user_id
    @username = user.username
    @email = user.email
    @first_name = user.first_name
    @surname = user.surname
    @password = user.password
    session[:temp_username] = @username

    if user.is_suspended == 0
      @account_status = "ACTIVE"
    else
      @account_status = "SUSPENDED"
    end
    

    @academic_major = user.academic_major
    
    @academic_level = user.academic_level

    if user.account_type == "1"
      @account_type = "LEARNER"
    elsif user.account_type == "2"
      @account_type = "MODERATOR"
    elsif user.account_type == "3"
      @account_type = "MANAGER"
    elsif user.account_type == "4"
      @account_type = "ADMINISTRATOR"
    elsif user.account_type == "5"
      @account_type = "COURSE PROVIDER"
    elsif user.account_type == "6"
      @account_type = "COURSE PROVIDER - CONTRIBUTOR"
    elsif user.account_type == "7"
      @account_type = "MODERATOR + USER"
    elsif user.account_type == "8"
      @account_type = "MANAGER + USER"
    elsif user.account_type == "9"
      @account_type = "ADMINISTRATOR + USER"
    else
      @account_type = "LEARNER"
    end

    @sign_up_date = user.sign_up_date

    erb :"user/user_profile"
  else
    erb :sign_in
  end
end

get "/moderator-profile" do
  if session[:account_type].to_i == 2 || session[:account_type].to_i == 7
    user = User.load_user(session[:email])
  
    @user = User[user.user_id]

    @user_id = user.user_id
    @username = user.username
    @email = user.email
    @first_name = user.first_name
    @surname = user.surname
    @password = user.password
    session[:temp_username] = @username

    if user.is_suspended == 0
      @account_status = "ACTIVE"
    else
      @account_status = "SUSPENDED"
    end
    
    @academic_major = user.academic_major
    @academic_level = user.academic_level

    if user.account_type == "1"
      @account_type = "LEARNER"
    elsif user.account_type == "2"
      @account_type = "MODERATOR"
    elsif user.account_type == "3"
      @account_type = "MANAGER"
    elsif user.account_type == "4"
      @account_type = "ADMINISTRATOR"
    elsif user.account_type == "5"
      @account_type = "COURSE PROVIDER"
    elsif user.account_type == "6"
      @account_type = "COURSE PROVIDER - CONTRIBUTOR"
    elsif user.account_type == "7"
      @account_type = "MODERATOR + USER"
    elsif user.account_type == "8"
      @account_type = "MANAGER + USER"
    elsif user.account_type == "9"
      @account_type = "ADMINISTRATOR + USER"
    else
      @account_type = "LEARNER"
    end

    @sign_up_date = user.sign_up_date

    erb :"moderator/moderator_profile"
  else
    erb :sign_in
  end
end

get "/manager-profile" do
  if session[:account_type].to_i == 3 || session[:account_type].to_i == 8
    user = User.load_user(session[:email])

    @user = User[user.user_id]

    @user_id = user.user_id
    @username = user.username
    @email = user.email
    @first_name = user.first_name
    @surname = user.surname
    @password = user.password
    session[:temp_username] = @username

    if user.is_suspended == 0
      @account_status = "ACTIVE"
    else
      @account_status = "SUSPENDED"
    end
    
    @academic_major = user.academic_major
    @academic_level = user.academic_level

    if user.account_type == "1"
      @account_type = "LEARNER"
    elsif user.account_type == "2"
      @account_type = "MODERATOR"
    elsif user.account_type == "3"
      @account_type = "MANAGER"
    elsif user.account_type == "4"
      @account_type = "ADMINISTRATOR"
    elsif user.account_type == "5"
      @account_type = "COURSE PROVIDER"
    elsif user.account_type == "6"
      @account_type = "COURSE PROVIDER - CONTRIBUTOR"
    elsif user.account_type == "7"
      @account_type = "MODERATOR + USER"
    elsif user.account_type == "8"
      @account_type = "MANAGER + USER"
    elsif user.account_type == "9"
      @account_type = "ADMINISTRATOR + USER"
    else
      @account_type = "LEARNER"
    end

    @sign_up_date = user.sign_up_date

    erb :"manager/manager_profile"
  else
    erb :sign_in
  end
end

get "/administrator-profile" do
  if session[:account_type].to_i == 4 || session[:account_type].to_i == 9
    user = User.load_user(session[:email])
  
    @user = User[user.user_id]

    @user_id = user.user_id
    @username = user.username
    @email = user.email
    @first_name = user.first_name
    @surname = user.surname
    @password = user.password
    session[:temp_username] = @username


    if user.is_suspended == 0
      @account_status = "ACTIVE"
    else
      @account_status = "SUSPENDED"
    end
    
    @academic_major = user.academic_major
    @academic_level = user.academic_level

    if user.account_type == "1"
      @account_type = "LEARNER"
    elsif user.account_type == "2"
      @account_type = "MODERATOR"
    elsif user.account_type == "3"
      @account_type = "MANAGER"
    elsif user.account_type == "4"
      @account_type = "ADMINISTRATOR"
    elsif user.account_type == "5"
      @account_type = "COURSE PROVIDER"
    elsif user.account_type == "6"
      @account_type = "COURSE PROVIDER - CONTRIBUTOR"
    elsif user.account_type == "7"
      @account_type = "MODERATOR + USER"
    elsif user.account_type == "8"
      @account_type = "MANAGER + USER"
    elsif user.account_type == "9"
      @account_type = "ADMINISTRATOR + USER"
    else
      @account_type = "LEARNER"
    end

    @sign_up_date = user.sign_up_date

    erb :"administrator/administrator_profile"
  else
    erb :sign_in
  end
end
  
post "/update-profile" do
  user = User.load_user(session[:email])

  @user = User[user.user_id]

  @user_id = user.user_id
  @username = user.username
  @email = user.email
  @first_name = user.first_name
  @surname = user.surname

  if user.is_suspended == 0
    @account_status = "ACTIVE"
  else
    @account_status = "SUSPENDED"
  end
  
  @academic_major = user.academic_major
  @academic_level = user.academic_level

  if user.account_type == "1"
    @account_type = "LEARNER"
  elsif user.account_type == "2"
    @account_type = "MODERATOR"
  elsif user.account_type == "3"
    @account_type = "MANAGER"
  elsif user.account_type == "4"
    @account_type = "ADMINISTRATOR"
  elsif user.account_type == "5"
    @account_type = "COURSE PROVIDER"
  elsif user.account_type == "6"
    @account_type = "COURSE PROVIDER - CONTRIBUTOR"
  elsif user.account_type == "7"
    @account_type = "MODERATOR + USER"
  elsif user.account_type == "8"
    @account_type = "MANAGER + USER"
  elsif user.account_type == "9"
    @account_type = "ADMINISTRATOR + USER"
  else
    @account_type = "LEARNER"
  end

  @sign_up_date = user.sign_up_date

  user_id = params["user_id"]

  if !user_id.nil?
    @user = User[user_id]
    @profile = User.new
    @user.load(params)

    if @user.valid?
      session[:logged_in] = true
      session[:username] = @user.username
      session[:email] = @user.email
      session[:account_type] = @user.account_type
      session[:user_id] = @user.user_id
      @user.save_changes
      flash[:success] = "Profile updated successfully"
      if user.account_type == "1"
        redirect "/user-profile"
      elsif user.account_type == "2"
        redirect "/moderator-profile"
      elsif user.account_type == "3"
        redirect "/manager-profile"
      elsif user.account_type == "4"
        redirect "/administrator-profile"
      elsif user.account_type == "5"
        redirect "/course-provider-profile"
      elsif user.account_type == "6"
        redirect "/course-provider-contributor-profile"
      elsif user.account_type == "7"
        redirect "/moderator-profile"
      elsif user.account_type == "8"
        redirect "/manager-profile"
      elsif user.account_type == "9"
        redirect "/administrator-profile"
      else
        redirect "/sign-in"
      end
    else
      flash[:error] = @profile.errors.full_messages
      if user.account_type == "1"
        redirect "/user-profile"
      elsif user.account_type == "2"
        redirect "/moderator-profile"
      elsif user.account_type == "3"
        redirect "/manager-profile"
      elsif user.account_type == "4"
        redirect "/administrator-profile"
      elsif user.account_type == "5"
        redirect "/course-provider-profile"
      elsif user.account_type == "6"
        redirect "/course-provider-contributor-profile"
      elsif user.account_type == "7"
        redirect "/moderator-profile"
      elsif user.account_type == "8"
        redirect "/manager-profile"
      elsif user.account_type == "9"
        redirect "/administrator-profile"
      else
        redirect "/sign-in"
      end
    end
  end

  if user.account_type == "1"
    erb :"user/user_profile"
  elsif user.account_type == "5" || user.account_type == "6"
    erb :"course_provider/course_provider_profile"
  elsif user.account_type == "2" || user.account_type == "7"
    erb :"moderator/moderator_profile"
  elsif user.account_type == "3" || user.account_type == "8"
    erb :"manager/manager_profile"
  elsif user.account_type == "4" || user.account_type == "9"
    erb :"administrator/administrator_profile"
  else
    erb :sign_in
  end
end