require_relative "../spec_helper"

describe "the moderator-send-message" do
  it "will send a message to users if everything is filled in" do
    clear_database
    clear_broadcasts
    add_admin
    #moderator account
    create_moderator
    click_on "Sign Out"
    signin_moderator
    visit "/moderator-send-message"
    expect(page).to have_content "Send Message"
    fill_in "subject", with: "Subject test"
    fill_in "content", with: "Message test"
    click_button "Submit"
    click_on "Sign Out"
    signup_new_user
    click_on "Messages"
    expect(page).to have_content "Look up a specific message"
    clear_database
    clear_broadcasts
  end

end