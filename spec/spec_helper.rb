# Configure coverage logging
require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end
# SimpleCov.coverage_dir "coverage"

# Ensure we use the test database
ENV["APP_ENV"] = "test"

# load the app
require_relative "../app"

# Configure Capybara
require "capybara/rspec"
Capybara.app = Sinatra::Application

# Configure RSpec
require "rack/test"
def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rack::Test::Methods
end

#user add function
def signup_new_user
  visit "/sign-up"
  fill_in "first_name", with: "Peter"
  fill_in "surname", with: "Cole"
  fill_in "username", with: "PeterCole"
  fill_in "email", with: "petercole@gmail.com"
  fill_in "password", with: "test"
  click_button "Submit"
end
  
#sign in functuon
def signin_existing_user
  visit "/sign-in"
  fill_in "email", with: "petercole@gmail.com"
  fill_in "password", with: "test"
  click_button "Submit"
end

def contact_form
  visit "/contact"
  fill_in "username", with: "PeterCole"
  fill_in "email", with: "petercole@gmail.com"
  fill_in "message", with: "Sending my message"
  click_button "Submit"
end

def add_admin
  visit "/sign-up-admin"
  fill_in "first_name", with: "Admin"
  fill_in "surname", with: "Admin"
  fill_in "username", with: "Admin"
  fill_in "email", with: "admin@gmail.com"
  fill_in "password", with: "admin"
  click_button "Submit"
end

def signin_admin
  visit "/sign-in"
  fill_in "email", with:"admin@gmail.com"
  fill_in "password", with:"admin"
  click_button "Submit"
end

def create_moderator
  visit "/administrator-add-new-authority"
  # click_link "Add New Authority"
  fill_in "first_name", with:"moderator"
  fill_in "surname", with:"moderator"
  fill_in "email", with:"moderator1@moderator.com"
  fill_in "username", with:"moderator1"
  select("Moderator", from: "account_type")
  fill_in "password", with:"moderator1"
  click_button "Register Authority"
end

def signin_moderator
  visit "/sign-in"
  fill_in "email", with:"moderator1@moderator.com"
  fill_in "password", with:"moderator1"
  click_button "Submit"
end

def add_to_course_db
  visit "/moderator-add-course"
  fill_in "course_name", with: "Introduction to Machine Learning"
  fill_in "company", with: "IBM"
  fill_in "course_description", with: "You will get to understand machine learning better."
  fill_in "course_hours", with: "15"
  fill_in "course_minutes", with: "30"
  select("Available", from: "availability")
  fill_in "enrollment_link", with: "ibm/machinelearning.org"
  select("Computer Science", from: "topic")
  click_button "Add Course"
end

def create_manager
    visit "/administrator-add-new-authority"
    # click_link "Add New Authority"
    fill_in "first_name", with:"manager"
    fill_in "surname", with:"manager"
    fill_in "email", with:"manager1@manager.com"
    fill_in "username", with:"manager1"
    select("Manager", from: "account_type")
    fill_in "password", with:"manager1"
    click_button "Register Authority"
end

def signin_manager
    visit "/sign-in"
    fill_in "email", with:"manager1@manager.com"
    fill_in "password", with:"manager1"
    click_button "Submit"
end

def request_course_provider
    visit "/"
    visit "/contact"
    click_link "Becoming a course provider"
    fill_in "company_name", with:"Deloitte"
    fill_in "company_email", with:"deloitte@gmail.com"
    fill_in "link", with:"https.deloitte"
    fill_in "notes", with:"deloitte provider"
    click_button "Submit"
end

def signup_course_provider
    visit "/contact"
    visit "/account-request-success"
    fill_in "first_name", with:"Deloitte"
    fill_in "surname", with:"Deloitte"
    fill_in "password", with:"Deloitte"
    click_button "Sign Up"
end

#clear out the database
def clear_database
  DB.from("users").delete
end

def clear_reviews
    DB.from("reviews").delete
end

def clear_contact
  DB.from("contact_forms").delete
end

def clear_courses
  DB.from("courses").delete
end

def clear_wishlist
    DB.from("wishlists").delete
end
def clear_broadcasts
  DB.from("broadcasts").delete
end

def clear_account_creation_requests
  DB.from("account_creation_requests").delete
end

def clear_enrollments
    DB.from("enrollments").delete
end
