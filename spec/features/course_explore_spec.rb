require_relative "../spec_helper"

describe "selecting a course without sign up or sign in" do

  it "is accessible from the home page" do
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
    visit "/"
    click_link "Explore"
    expect(page).to have_content "Explore Courses"
    click_button "Enroll"
    expect(page).to have_content "Sign In"
    clear_enrollments
    clear_courses
    clear_database
  end
end
