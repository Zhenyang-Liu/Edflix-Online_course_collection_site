require_relative "../spec_helper"

describe "Writing a review" do

  it "is accessible from the explore page" do
    clear_reviews
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
    expect(page).to have_content "Write a review"
    fill_in "content", with: "Good course"
    click_button "Submit the review"
    expect(page).to have_content "Good course"
    clear_reviews
    clear_courses
    clear_database
  end

end
