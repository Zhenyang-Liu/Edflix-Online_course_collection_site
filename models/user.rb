class User < Sequel::Model
  set_dataset DB[:users]
  plugin :validation_helpers

  one_to_many :password_resets
  
  # validating user input [.valid?] method using validation_helpers plugin
  def validate
    super
    validates_presence [:first_name, :surname, :username, :email, :password], message: "cannot be empty"
    validates_unique :username, :email, message: 'is already taken'
  end

  # signup method which store new user with AES encryption for password using salt & iv (initialization vector)
  def signup(params)
    self.username = params.fetch("username", "").strip
    self.email = params.fetch("email", "").strip
    self.first_name = params.fetch("first_name", "").strip
    self.surname = params.fetch("surname", "").strip

    account_type = params.fetch("account_type", "").strip

    if account_type == "Moderator"
      account_type = "2"
    elsif account_type == "Manager"
      account_type = "3"
    elsif account_type == "Administrator"
      account_type = "4"
    elsif account_type == "Course Provider"
      account_type = "5"
      self.is_suspended = 2
      self.request_id = params.fetch("request_id", "").strip
    elsif account_type == "Contributor"
      account_type = "6"
      self.company = params.fetch("company_name", "").strip
    elsif account_type == "Moderator + User"
      account_type = "7"
    elsif account_type == "Manager + User"
      account_type = "8"
    elsif account_type == "Administrator + User"
      account_type = "9"
    else
      account_type = "1"
    end
    self.account_type = account_type
    
    password_plain = params.fetch("password", "").strip
    if !password_plain.empty?
      # AES encryption take place
      begin
        aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
        self.iv = Sequel.blob(aes.random_iv)
        self.salt = Sequel.blob(OpenSSL::Random.random_bytes(16))
        aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password_plain, salt, 20_000, 16)
        self.password = Sequel.blob(aes.update(password_plain) + aes.final)
      end
    end
  end

  def assign_new_password(params)
    password_plain = params.fetch("password", "").strip
    begin
      aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      self.iv = Sequel.blob(aes.random_iv)
      self.salt = Sequel.blob(OpenSSL::Random.random_bytes(16))
      aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password_plain, salt, 20_000, 16)
      self.password = Sequel.blob(aes.update(password_plain) + aes.final)
    end
    save_changes
  end


  def assign_new_password_email(params)
    password_plain = params.fetch("password", "").strip
    password_confirmation = params.fetch("password_confirmation", "").strip

    if password_plain != password_confirmation
      return false
    end

    begin
      aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      self.iv = Sequel.blob(aes.random_iv)
      self.salt = Sequel.blob(OpenSSL::Random.random_bytes(16))
      aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password_plain, salt, 20_000, 16)
      self.password = Sequel.blob(aes.update(password_plain) + aes.final)
    end
    save_changes
  end
  
  
  # authenticate user attempt during login
  def authenticate(password_attempt)
    encrypted_password_attempt = encrypt_password_attempt(password_attempt)
    !encrypted_password_attempt.nil? && encrypted_password_attempt == password
  end  
  
  # encrypt the entered password attempt when login
  def encrypt_password_attempt(password_attempt)
    return nil if iv.nil? || salt.nil?
  
    begin
      aes = OpenSSL::Cipher.new('AES-128-CBC').encrypt
      aes.iv = iv
      aes.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(password_attempt, salt, 20_000, 16)
      encrypted_password_attempt = Sequel.blob(aes.update(password_attempt) + aes.final)
      encrypted_password_attempt
    rescue => e
      nil
    end
  
    encrypted_password_attempt
  end
  
  # load user data 
  def self.load_user(email)
    user_data = DB[:users].where(email: email).first
    return nil if user_data.nil?
  
    user = User.new
    user.user_id = user_data[:user_id]
    user.username = user_data[:username]
    user.email = user_data[:email]
    user.first_name = user_data[:first_name]
    user.surname = user_data[:surname]
    user.is_suspended = user_data[:is_suspended]
    user.account_type = user_data[:account_type]
    user.password = user_data[:password]
    user.iv = user_data[:iv]
    user.salt = user_data[:salt]
    user.academic_major = user_data[:academic_major]
    user.academic_level = user_data[:academic_level]
    user.request_id = user_data[:request_id]
    user.company = user_data[:company]
    time = Time.now
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S")
    user.sign_up_date = formatted_time
    user
  end

  # query for user search features
  def self.user_management_search(query)
    query = begin
              Integer(query)
            rescue ArgumentError
              query
            end
  
    id_result = query.is_a?(Integer) ? User.where(user_id: query).all : []
    username_result = query.is_a?(String) ? User.where(username: query).all : []
  
    result = id_result + username_result
    result
  end

  # check for suspension status for user [suspended code = 1]
  def is_suspended_user?
    self.is_suspended == 1
  end
  
  # suspend user account by changing and saving is_suspended value to '1'
  def suspend_user
    self.is_suspended = 1
    save_changes
  end

  # unsuspend user account by changing and saving is_suspended value to '0'
  def unsuspend_user
    self.is_suspended = 0
    save_changes
  end

  def reset_password
    self.password = "reset"
    self.iv = nil
    self.salt = nil
    save_changes
  end

  def awaiting_approval_user
    self.is_suspended = 2
    save_changes
  end

  def self.load_all_users
    User.all
  end

  def self.load_contributor(company)
    User.where(company: company).all
  end

  def get_email
    "#{email}"
  end
  
  def get_user_id
    "#{user_id}"
  end
  
  def name
    "#{first_name} #{surname}"
  end

  # update user profile
  
  def self.username_exists?(username)
    return false if username.nil? # check the id is not nil
    return false if User[username].nil? # check the database has a record with this id

    true # all checks are ok - the id exists
  end

  # store the data written on the forms (params) to the users database
  def load(params)
    self.user_id = params.fetch("user_id", "").strip
    self.username = params.fetch("username", "").strip
    self.email = params.fetch("email", "").strip
    self.first_name = params.fetch("first_name", "").strip
    self.surname = params.fetch("surname", "").strip
    self.academic_major = params.fetch("academic_major", "").strip
    self.academic_level = params.fetch("academic_level", "").strip
    time = Time.now
    formatted_time = time.strftime("%Y-%m-%d %H:%M")
    self.sign_up_date = formatted_time
  end

  def self.filter_users(criteria)
    if criteria == "normal"
      User.where(is_suspended: 0).all
    elsif criteria == "suspended"
      User.where(is_suspended: 1).all
    else
      User.all
    end
  end

  def self.get_username_by_id(user_id)
    if user_id
      user = User.where(user_id: user_id).first
      user.username
    else
      nil
    end
  end

  
  def generate_password_reset_token
    token = SecureRandom.urlsafe_base64
    # Expires in 1 hour
    expires_at = Time.now + 3600 

    # Delete expired reset tokens
    password_resets_dataset.where { password_reset_token_expires_at <= Time.now }.delete

    # Create a new reset token
    add_password_reset(password_reset_token: token, password_reset_token_expires_at: expires_at)
  end

end



