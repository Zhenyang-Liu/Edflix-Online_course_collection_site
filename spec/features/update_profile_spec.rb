require_relative "../spec_helper"

describe "the user profile page" do
  it "is accessible from the user dashboard" do
    clear_database
    signup_new_user
    click_link "Profile"
    expect(page).to have_content "Profile"
    click_button "Click to Edit Profile"
    expect(page). to have_content "Profile"
    fill_in "first_name", with: "Bob"
    find_by_id('buttonUpdate', visible:false)
    # click_button "Update Profile"
    expect(page).to have_content "Profile"
    click_on "Sign Out"
    clear_database
  end
end