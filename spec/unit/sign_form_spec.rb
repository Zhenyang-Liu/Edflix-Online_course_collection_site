require "rspec"
require "rack/test"

require_relative "../../app"

RSpec.describe "Sign_up page valdation" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "Form Submission" do
    it "says latest updates when all the fields are filled in" do
      get "/sign-up", "first_name" => "Some Text", "surname" => "Some Text", "username" => "Some Text", "password" => "Some Text", "email" => "Some Text"
      expect(last_response.body).to include("Getting Started")
    end

    it "rejects the form when first_name is not filled out" do
      get "/sign-up", "surname" => "Some Text", "username" => "Some Text", "password" => "Some Text", "email" => "Some Text"
      expect(last_response.body).to include("First name cannot be empty")
    end

    it "rejects the form when surname is not filled out" do
      get "/sign-up", "first_name" => "Some Text", "username" => "Some Text", "password" => "Some Text", "email" => "Some Text"
      expect(last_response.body).to include("Surname cannot be empty")
    end

    it "rejects the form when username is not filled out" do
        get "/sign-up", "first_name" => "Some Text", "surname" => "Some Text", "password" => "Some Text", "email" => "Some Text"
        expect(last_response.body).to include("Username cannot be empty")
    end

    it "rejects the form when password is not filled out" do
        get "/sign-up", "first_name" => "Some Text", "username" => "Some Text", "surname" => "Some Text", "email" => "Some Text"
        expect(last_response.body).to include("Password cannot be empty")
    end

    it "rejects the form when email is not filled out" do
        get "/sign-up", "first_name" => "Some Text", "username" => "Some Text", "password" => "Some Text", "surname" => "Some Text"
        expect(last_response.body).to include("Email cannot be empty")
    end
    
  end
end
