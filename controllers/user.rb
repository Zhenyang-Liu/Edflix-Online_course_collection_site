# user routes
get "/user-dashboard" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    redirect "/user-profile"
  else
    erb :sign_in
  end
end

get "/my-course" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    @enrollments = Enrollment.for_user(session[:user_id])
    erb :"user/user_my_course"
  else
    erb :sign_in
  end
end

post "/mark_course_completed/:id" do
  current_user_id = session[:user_id]
  course_id = params[:id]
  Enrollment.mark_course_completed(current_user_id, course_id)
  redirect "/my-course"
end

post "/mark_course_incompleted/:id" do
  current_user_id = session[:user_id]
  course_id = params[:id]
  Enrollment.mark_course_incompleted(current_user_id, course_id)
  redirect "/my-course"
end

get "/my-wishlist" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    @wishlists = Wishlist.where(user_id: session[:user_id])
    erb :"user/user_my_wishlist"
  else
    erb :sign_in
  end
end

get "/user-notification" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    erb :"user/user_notification"
  else
    erb :sign_in
  end
end

get "/my-badges" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    erb :"user/user_my_badges"
  else
    erb :sign_in
  end
end

get "/user_course_referral" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    erb :"user/user_course_referral"
  else
    erb :sign_in
  end
end

post '/course_referral' do
  @course = Courses_waiting_list.new
  @course.load(params)

  if @course.save
    flash[:success] = "Course successfully Referred"
    redirect '/user_course_referral'
  else
    "Error submitting the form"
  end
end

get "/user-support" do
  if session[:account_type].to_i == 1 || session[:account_type].to_i == 7 || session[:account_type].to_i == 8 || session[:account_type].to_i == 9
    erb :"user/user_support"
  else
    erb :sign_in
  end
end 

post "/cancel-enrolled-course/:id" do
  current_user_id = session[:user_id]
  if current_user_id
    course_id = params[:id]

    if !Enrollment.delete_enrollment(current_user_id, course_id)
      flash[:enrolled_error] = "The enrollment does not exist"
      redirect "/explore"
    else
      if request.xhr?
        status 200
      else
        redirect back
      end
    end
  end
end


post "/enroll-course/:id" do
  current_user_id = session[:user_id]
  if current_user_id
    course_id = params[:id]
    if !Enrollment.find_record(current_user_id, course_id)
      if !Enrollment.add_enrollment(current_user_id, course_id)
        flash[:enrolled_error] = "The course does not exist"
        redirect "/explore"
      else
        if Wishlist.find_record(current_user_id, course_id)
          Wishlist.delete_wishlist(current_user_id, course_id)
        end
        if request.xhr? 
          status 200
        else
          redirect back 
        end
      end
    else
      flash[:enrolled_error] = "The enrollment has existed"
      redirect "/explore"
    end
  else
    if request.xhr? 
      headers['X-Redirect-URL'] = "/sign-in"
      status 401
    else
      redirect "/sign-in"
    end
  end
end


get "/user-messages" do
  @broadcasts = Broadcast.all
             
  @subject_search = params.fetch("subject_search", "").strip

  @broadcasts = if @subject_search.empty?
                  Broadcast.all
                else
                  Broadcast.where(Sequel.like(:subject, "%#{@subject_search}%"))
                end
  erb :"user/user_messages"
end

post "/withdraw-from-wishlist/:id" do
  current_user_id = session[:user_id]
  if current_user_id
    course_id = params[:id]

    if !Wishlist.delete_wishlist(current_user_id, course_id)
      flash[:enrolled_error] = "The wishlist does not exist"
      redirect "/explore"
    else
      if request.xhr?
        status 200
      else
        redirect back
      end
    end
  end
end


post "/add-to-wishlist/:id" do
  current_user_id = session[:user_id]
  if current_user_id
    course_id = params[:id]
    if !Wishlist.add_wishlist(current_user_id, course_id)
      flash[:enrolled_error] = "The wishlist does not exist"
      redirect "/explore"
    else
      if request.xhr? 
        status 200
      else
        redirect back 
      end
    end
  else
    if request.xhr? 
      headers['X-Redirect-URL'] = "/sign-in"
      status 401
    else
      redirect "/sign-in"
    end
  end
end



