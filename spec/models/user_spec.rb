require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      organisation = Organisation.create(name: "Test Org", country: "USA", language: "English")
      user = User.new(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
      expect(user).to be_valid
    end

    it "is valid without an organisation" do
      user = User.new(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: nil
      )
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = User.new(name: nil)
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid without an email" do
      user = User.new(email: nil)
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with a duplicate email" do
      User.create(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active"
      )
      
      user = User.new(
        name: "Jane Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active"
      )
      
      user.valid?
      expect(user.errors[:email]).to include("has already been taken")
    end
  end

  describe "associations" do
    it "belongs to organisation (optional)" do
      association = User.reflect_on_association(:organisation)
      expect(association.macro).to eq :belongs_to
      expect(association.options[:optional]).to eq true
    end

    it "has many posts" do
      association = User.reflect_on_association(:posts)
      expect(association.macro).to eq :has_many
    end
  end

  describe "status methods" do
    let(:user) { User.new(status: "active") }
    let(:departed_user) { User.new(status: "departed") }

    it "#active? returns true when status is active" do
      expect(user.active?).to be true
      expect(departed_user.active?).to be false
    end

    it "#departed? returns true when status is departed" do
      expect(user.departed?).to be false
      expect(departed_user.departed?).to be true
    end

    it "#depart! changes status to departed" do
      user.depart!
      expect(user.status).to eq "departed"
    end

    it "#reactivate! changes status to active" do
      departed_user.reactivate!
      expect(departed_user.status).to eq "active"
    end
  end

  describe "organisation methods" do
    it "#organisation_name returns the organisation name" do
      organisation = Organisation.create(name: "Test Org")
      user = User.new(organisation: organisation)
      expect(user.organisation_name).to eq "Test Org"
    end

    it "#organisation_name returns nil when user has no organisation" do
      user = User.new(organisation: nil)
      expect(user.organisation_name).to be_nil
    end
  end
end 