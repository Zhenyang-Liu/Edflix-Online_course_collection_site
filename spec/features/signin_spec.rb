require_relative "../spec_helper"

describe "the sign in page" do
  it "is accessible from the home page" do
    visit "/"
    click_link "Sign In"
    expect(page).to have_content "Welcome Back Time to Study"
  end


  it "signs in a user when all details are entered and match correctly the database" do
    clear_database
    signup_new_user
    click_on "Sign Out"
    signin_existing_user
    expect(page).to have_content "Profile"
    clear_database
  end

end