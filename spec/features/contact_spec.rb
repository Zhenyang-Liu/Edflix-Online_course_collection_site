require_relative "../spec_helper"

describe "the contact" do
  it "is accessible from the home page" do
    visit "/"
    click_link "Contact"
    expect(page).to have_content "Get in Touch?"
  end

  it "will not submit a message without the fields being filled in" do
    visit "/contact"
    click_button "Submit"
    expect(page).to have_content "Please correct the errors below:"
  end

  it "submits the message when all the fields are filled in" do
    visit "/contact"
    contact_form
    click_button "Submit"    
    clear_contact
    expect(page).to have_content "Please leave a message regarding your enquiry or problem"
  end
end
