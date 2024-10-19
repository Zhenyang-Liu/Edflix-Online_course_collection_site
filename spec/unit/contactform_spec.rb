require "rspec"
require "rack/test"

require_relative "../../app"

RSpec.describe "Contact-form page valdation" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "Contact Form Submission" do
    it "Submits the message when all the fields are filled in" do
      get "/contact", "username" => "Some Text", "email" => "Some Text", "message" => "Some Text"
      expect(last_response.body).to include("Please leave a message regarding your enquiry or problem")
    end

    it "rejects the form when username is not filled out" do
      post "/contact", "email" => "Some Text", "message" => "Some Text"
      expect(last_response.body).to include("Username cannot be empty")
    end

    it "rejects the form when email is not filled out" do
      post "/contact", "username" => "Some Text", "message" => "Some Text"
      expect(last_response.body).to include("Email cannot be empty")
    end

    it "rejects the form when message is not filled out" do
        post "/contact", "username" => "Some Text", "email" => "Some Text"
        expect(last_response.body).to include("Message cannot be empty")
    end

    it "rejects the form when no fields in the form are filled" do
        post "/contact", "first_name" => "Some Text", "username" => "Some Text", "surname" => "Some Text", "email" => "Some Text"
        expect(last_response.body).to include("Please correct the errors below:")
    end    
  end
end
