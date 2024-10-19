class Contact_form < Sequel::Model

  def load(params)
    #takes the params hash and set oas fields of the object
      self.username = params.fetch("username", "").strip
      self.email = params.fetch("email", "").strip
      self.message = params.fetch("message", "").strip
  end

  def validate
    #makes sure that all required fields of the contact form is filled in 
      super
      errors.add("username", "cannot be empty") if !username || username.empty?
      errors.add("email", "cannot be empty") if !email || email.empty?
      errors.add("message", "cannot be empty") if !message || message.empty?
    end

end