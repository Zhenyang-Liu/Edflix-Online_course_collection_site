require_relative "../spec_helper"

describe "Becoming a course provider" do
  #when awaiting approval
  it "adds a course provider from authorised companies" do
    clear_database
    clear_account_creation_requests
    #course provider account
    request_course_provider
    signup_course_provider
    expect(page).to have_content "Your Account is Under Review"
    click_on "Sign Out"
    clear_database
    clear_account_creation_requests
  end

end
