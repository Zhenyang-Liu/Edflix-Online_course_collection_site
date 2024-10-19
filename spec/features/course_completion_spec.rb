require_relative "../spec_helper"

describe "With one course - a user completing a course or marking as incomplete" do

  it "is accessible from the user dashboard" do
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
    click_link "My Courses"
    expect(page).to have_content "Courses in progress"
    click_button "Mark Completed"
    expect(page).to have_content "Courses completed"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end

  it "is accessible from the user dashboard" do
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
    click_link "My Courses"
    expect(page).to have_content "Courses in progress"
    click_button "Mark Completed"
    expect(page).to have_content "Courses completed"
    click_button "Mark Incompleted"
    expect(page).to have_content "Courses in progress"
    click_on "Sign Out"
    clear_enrollments
    clear_courses
    clear_database
  end
end
