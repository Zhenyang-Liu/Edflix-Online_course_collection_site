class PasswordReset < Sequel::Model
  many_to_one :user
end