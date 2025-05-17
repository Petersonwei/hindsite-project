require 'rails_helper'

RSpec.describe Post, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      organisation = Organisation.create(name: "Test Org", country: "USA", language: "English")
      user = User.create(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
      
      post = Post.new(description: "Test post", user: user)
      expect(post).to be_valid
    end
    
    it "is invalid without a description" do
      post = Post.new(description: nil)
      post.valid?
      expect(post.errors[:description]).to include("can't be blank")
    end
    
    it "is invalid without a user" do
      post = Post.new(user: nil)
      post.valid?
      expect(post.errors[:user]).to include("must exist")
    end
  end
  
  describe "associations" do
    it "belongs to user" do
      association = Post.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end
  
  describe "dependent destroy" do
    it "is deleted when the user is deleted" do
      organisation = Organisation.create(name: "Test Org", country: "USA", language: "English")
      user = User.create(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
      
      post = Post.create(description: "Test post", user: user)
      expect { user.destroy }.to change { Post.count }.by(-1)
    end
  end
end 