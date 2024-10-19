require_relative "../spec_helper"

describe "accessing the course page" do
  it "is accessible from the user dashboard" do
    clear_database
    visit "/"
    signup_new_user
    visit "/explore"
    expect(page).to have_content "Explore Courses"
    visit "/user-dashboard"
    click_on "Sign Out"
    clear_database
  end  
  
  it "adds the course to the user dashboard" do
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
    signup_new_user
    visit "/explore"
    click_button "Enroll"
    visit "/user-dashboard"
    visit "/my-course"
    expect(page).to have_content "Courses in progress"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end
  it "cancels a course a user was enrolled in" do
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
    signup_new_user
    visit "/explore"
    click_button "Enroll"
    visit "/user-dashboard"
    visit "/my-course"
    expect(page).to have_content "Courses in progress"
    visit "/explore"
    click_button "Cancel"
    #page will be empty
    visit "/user-dashboard"
    visit "/my-course"
    expect(page).to have_content "My Courses"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database

  end

end
