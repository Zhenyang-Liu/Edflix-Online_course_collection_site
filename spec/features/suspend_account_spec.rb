require_relative "../spec_helper"

describe "suspending an account" do
  it "is accessible from the admin dashboard" do
    clear_database
    signup_new_user
    click_on "Sign Out"
    add_admin
    click_link "Users Listing"
    first_button = page.first('button', text: 'Suspend')
    first_button.click
    click_on "Sign Out"
    signin_existing_user
    expect(page).to have_content "Your account has been suspended, please contact us for details."
    clear_database
  end

  it "is accessible from admin dashboard" do
    clear_database
    signup_new_user
    click_on "Sign Out"
    add_admin
    click_link "Users Listing"
    first_button = page.first('button', text: 'Suspend')
    first_button.click
    click_on "Sign Out"
    signin_existing_user
    expect(page).to have_content "Your account has been suspended, please contact us for details."
    signin_admin
    click_link "Users Listing"
    first_button = page.first('button', text: 'Unsuspend')
    first_button.click
    click_on "Sign Out"
    signin_existing_user
    expect(page).to have_content "Profile"
    clear_database

  end
end
