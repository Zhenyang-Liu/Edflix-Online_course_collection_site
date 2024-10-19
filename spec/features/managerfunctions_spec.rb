require_relative "../spec_helper"

describe "manager profile" do
  
  it "displays list of current users" do
    clear_database
    signup_new_user
    click_on "Sign Out"
    add_admin
    #moderator account
    create_manager
    click_on "Sign Out"
    signin_manager
    # add_course
    click_link "Users Listing"
    expect(page).to have_content "Users Listing"
    click_on "Sign Out"
    clear_database

  end

  it "displays list of current courses" do
    clear_enrollments
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
    clear_database
    add_admin
    #moderator account
    create_manager
    click_on "Sign Out"

    signin_manager
    # add_course
    click_link "Courses Listing"
    expect(page).to have_content "Introduction to Machine Learning"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end


end
