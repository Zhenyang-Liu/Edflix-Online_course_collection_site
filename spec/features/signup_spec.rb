require_relative "../spec_helper"

describe "the sign up page" do
  it "is accessible from the home page" do
    visit "/"
    click_link "Get Started"
    expect(page).to have_content "Getting Started"
  end

  it "will not add a user with no details" do
    visit "/sign-up"
    click_button "Submit"
    expect(page).to have_content "First name cannot be empty"
  end

  it "adds a user when all details are entered" do
    clear_database
    signup_new_user
    expect(page).to have_content "Profile"
    click_on "Sign Out"

  end

  it "rejects the sign up if the username or password already exists" do
    signup_new_user
    clear_database
    expect(page).to have_content "username is already taken"
  end
end
