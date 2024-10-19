class AccountCreationRequest < Sequel::Model
  set_dataset DB[:account_creation_requests]
  plugin :validation_helpers

  def load(params)
    #takes the params hash and set oas fields of the object
      self.company_name = params.fetch("company_name", "").strip
      self.company_email = params.fetch("company_email", "").strip
      
      account_type = params.fetch("account_type", "").strip
      if (account_type == "Course Provider")
        account_type = "5"
      elsif (account_type == "Moderator")
        account_type = "2"
      end

      self.account_type = account_type
      self.link = params.fetch("link", "").strip
      self.supporting_document = params.fetch("supporting_document", "").strip
      self.notes = params.fetch("note", "").strip
  end

  # load user data 
  def self.load_request(request_id)
    request_data = DB[:account_creation_requests].where(request_id: request_id).first
    return nil if request_data.nil?
  
    request = AccountCreationRequest.new
    request.request_id = request_data[:request_id]
    request.company_name = request_data[:company_name]
    request.company_email = request_data[:company_email]
    request.account_type = request_data[:account_type]
    request.link = request_data[:link]
    request.supporting_document = request_data[:supporting_document]
    request.notes = request_data[:notes]
    request.status = request_data[:status]
  
    request
  end

  def validate
    #makes sure that all required fields of the contact form is filled in 
      super
      errors.add("company name", "cannot be empty") if !company_name || company_name.empty?
      errors.add("company email", "cannot be empty") if !company_email || company_email.empty?

      validates_unique :company_name, :company_email, message: 'is already requested.'
  end

  # query for user search features
  def self.manager_account_request_search(query)
    query = begin
              Integer(query)
            rescue ArgumentError
              query
            end
  
    id_result = query.is_a?(Integer) ? AccountCreationRequest.where(request_id: query).all : []
    username_result = query.is_a?(String) ? AccountCreationRequest.where(company_name: query).all : []
  
    result = id_result + username_result
    result
  end

  def self.load_all_request
    AccountCreationRequest.all
  end

  # suspend user account by changing and saving is_suspended value to '1'
  def approve_request
    self.status = 0
    save_changes
  end

  # unsuspend user account by changing and saving is_suspended value to '0'
  def reject_request
    self.status = 1
    save_changes
  end

  def load(params)
    self.request_id = params.fetch("request_id", "").strip
    self.company_name = params.fetch("company_name", "").strip
    self.company_email = params.fetch("company_email", "").strip
    self.account_type = params.fetch("account_type", "").strip
    self.link = params.fetch("link", "").strip
    self.supporting_document = params.fetch("supporting_document", "").strip
    self.notes = params.fetch("notes", "").strip
    self.status = "2"
  end

  def self.load_course_provider
    u = AccountCreationRequest.where(account_type: "Course Provider", status: "0").all
  end

end