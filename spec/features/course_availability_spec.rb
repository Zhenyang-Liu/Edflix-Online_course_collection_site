require_relative "../spec_helper"

describe "course availability or unavailability" do
  it "is accessible from the moderator dashboard" do
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
    click_link "Courses Listing"
    click_button "Update"
    select("Not Available", from: "availability")
    click_button "Save"
    click_on "Sign Out"
    signup_new_user
    visit "/explore"
    expect(page).to have_content "Explore Courses"
    visit "/user-dashboard"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end

  it "deletes a course" do
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
    click_link "Courses Listing"
    click_button "Update"
    select("Available", from: "availability")
    click_button "Save"
    click_on "Sign Out"
    signup_new_user
    visit "/explore"
    expect(page).to have_content "Introduction to Machine Learning"
    visit "/user-dashboard"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end

end
