require 'rails_helper'

RSpec.describe Organisation, type: :model do
  describe "associations" do
    it "has many users" do
      association = Organisation.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
    end
  end

  describe "basic functionality" do
    it "can be created with valid attributes" do
      organisation = Organisation.new(
        name: "Test Org",
        country: "USA",
        language: "English"
      )
      expect(organisation).to be_valid
    end
  end
end 