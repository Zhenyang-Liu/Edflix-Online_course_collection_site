class AccountResetRequest < Sequel::Model
  set_dataset DB[:account_reset_requests]
  plugin :validation_helpers

  def load(params)
    #takes the params hash and set oas fields of the object
      self.username = params.fetch("username", "").strip
      self.email = params.fetch("email", "").strip    
      self.status = "2"  
  end

  def validate
    #makes sure that all required fields of the contact form is filled in 
      super
      errors.add("username", "cannot be empty") if !username || username.empty?
      errors.add("email", "cannot be empty") if !email || email.empty?
  end

  def self.load_all_account_reset_request
    AccountResetRequest.all
  end

  def reset_account
    self.status = "0"
    save_changes
  end
end