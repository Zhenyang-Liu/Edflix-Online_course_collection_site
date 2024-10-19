require_relative "../spec_helper"

RSpec.describe User do
  describe "#name" do
    it "returns the user's full name" do
      user = described_class.new(first_name: "A", surname: "B")
      expect(user.name).to eq("A B")
    end
  end

  describe "#get_email" do
    it "returns the email of the user" do
      user = described_class.new(email: "user1@gmail.com")
      expect(user.get_email).to eq("user1@gmail.com")
    end
  end


end