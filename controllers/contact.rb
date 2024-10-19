get "/contact" do
    @contact_form = Contact_form.new
    erb :contact
end

post "/contact" do
    @contact_form = Contact_form.new
    @contact_form.load(params)

    if @contact_form.valid?
        @contact_form.save_changes
        redirect "/contact"
    end

    erb :contact
end


get "/account-request" do
    @account_request_form =  AccountCreationRequest.new
    @account_type = params[:account_type]
    session[:temp_account_type] = @account_type
    erb :account_request
end

get "/account-request-success" do
    @requestDetail = AccountCreationRequest.find(company_name: session[:temp_account_username])
    erb :account_request_success
end

post "/account-request" do
    @account_request_form = AccountCreationRequest.new
    @account_type = params[:account_type]
    @account_request_form.load(params)

    if @account_request_form.valid?
        @account_request_form.save_changes
        session[:temp_account_username] = params.fetch("company_name", "").strip
        session[:temp_account_email] = params.fetch("company_email", "").strip
        flash[:success] = "Request sent successfully."
        redirect "/account-request-success"
    else
        flash.now[:error] = @account_request_form.errors.full_messages
        erb :account_request
    end

    erb :account_request
end

get "/account-reset-request" do
    @account_reset_request_form = AccountResetRequest.new
    erb :account_reset_request
end

get "/account-reset-request-email" do
    erb :account_reset_request_email
end


post "/account-reset-request" do
    @account_reset_request_form = AccountResetRequest.new
    @account_reset_request_form.load(params)

    if @account_reset_request_form.valid?
        @account_reset_request_form.save_changes
        flash[:success] = "Submit form successfully, we will contact you soon."
        redirect "/account-reset-request"
    else
        flash.now[:error] = @account_reset_request_form.errors.full_messages
        erb :account_reset_request
    end

    erb :account_reset_request
end
