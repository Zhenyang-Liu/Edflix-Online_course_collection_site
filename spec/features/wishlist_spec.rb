require_relative "../spec_helper"

describe "Adding a course to the wishlist" do

  it "is accessible from the explore page" do
    
    clear_wishlist
    clear_courses
    clear_database

    add_admin
    #moderator account
    create_moderator
    click_on "Sign Out"
    signin_moderator
    # add_course
    add_to_course_db
    click_on "Sign Out"
    signup_new_user
    visit "/explore"
    click_link "Introduction to Machine Learning"
    expect(page).to have_content "Introduction to Machine Learning"
    click_button "Add to wishlist"
    visit "/user-dashboard"
    click_link "Wishlist"
    expect(page).to have_content "My Course Wishlist"
    click_on "Sign Out"

    clear_wishlist
    clear_courses
    clear_database
  end

  it "is accessible from the user dashboard" do
    
    clear_wishlist
    clear_courses
    clear_database

    add_admin
    #moderator account
    create_moderator
    click_on "Sign Out"
    signin_moderator
    # add_course
    add_to_course_db
    click_on "Sign Out"
    signup_new_user
    visit "/explore"
    click_link "Introduction to Machine Learning"
    expect(page).to have_content "Introduction to Machine Learning"
    click_button "Add to wishlist"
    visit "/user-dashboard"
    click_link "Wishlist"
    expect(page).to have_content "My Course Wishlist"
    click_button "Withdraw"
    expect(page).to have_content "My Course Wishlist"
    click_on "Sign Out"
    clear_wishlist
    clear_courses
    clear_database
  end
end
