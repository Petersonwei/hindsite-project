require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:organisation) { Organisation.create!(name: "Test Org", country: "USA", language: "English") }
  
  let(:valid_attributes) {
    { description: "Test post description" }
  }

  let(:invalid_attributes) {
    { description: nil }
  }

  describe "unauthenticated user" do
    it "redirects to login page" do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end

  describe "authenticated user with organisation" do
    let(:user) {
      User.create!(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
    }
    
    let(:other_user) {
      User.create!(
        name: "Jane Doe",
        email: "jane@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: organisation
      )
    }
    
    let(:user_from_other_org) {
      other_org = Organisation.create!(name: "Other Org", country: "UK", language: "English")
      User.create!(
        name: "Bob Smith",
        email: "bob@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: other_org
      )
    }

    before do
      # Simulate login by setting the session
      session[:user_id] = user.id
    end

    describe "GET #index" do
      it "returns a success response" do
        Post.create!(description: "Test post 1", user: user)
        get :index
        expect(response).to be_successful
      end
      
      it "shows posts from users in the same organisation" do
        post1 = Post.create!(description: "Post by user", user: user)
        post2 = Post.create!(description: "Post by other user", user: other_user)
        post3 = Post.create!(description: "Post by user from other org", user: user_from_other_org)
        
        get :index
        expect(assigns(:posts)).to include(post1)
        expect(assigns(:posts)).to include(post2)
        expect(assigns(:posts)).not_to include(post3)
      end
    end
    
    describe "GET #departed_posts" do
      it "returns a success response" do
        get :departed_posts
        expect(response).to be_successful
      end
      
      it "shows posts from departed users in the same organisation" do
        departed_user = User.create!(
          name: "Departed User",
          email: "departed@example.com",
          password: "password123",
          password_confirmation: "password123",
          status: "departed",
          organisation: organisation
        )
        
        post1 = Post.create!(description: "Post by departed user", user: departed_user)
        post2 = Post.create!(description: "Post by active user", user: user)
        
        get :departed_posts
        expect(assigns(:departed_posts)).to include(post1)
        expect(assigns(:departed_posts)).not_to include(post2)
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        post = Post.create!(description: "Test post", user: user)
        get :show, params: { id: post.to_param }
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Post" do
          expect {
            post :create, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it "redirects to the created post" do
          post :create, params: { post: valid_attributes }
          expect(response).to redirect_to(Post.last)
        end
        
        it "assigns the current user as the post owner" do
          post :create, params: { post: valid_attributes }
          expect(Post.last.user).to eq(user)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { post: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PUT #update" do
      context "when updating own post" do
        let(:post_instance) { Post.create!(description: "Original post", user: user) }
        
        context "with valid params" do
          let(:new_attributes) {
            { description: "Updated post description" }
          }

          it "updates the requested post" do
            put :update, params: { id: post_instance.to_param, post: new_attributes }
            post_instance.reload
            expect(post_instance.description).to eq("Updated post description")
          end

          it "redirects to the post" do
            put :update, params: { id: post_instance.to_param, post: new_attributes }
            expect(response).to redirect_to(post_instance)
          end
        end

        context "with invalid params" do
          it "returns a success response (i.e. to display the 'edit' template)" do
            put :update, params: { id: post_instance.to_param, post: invalid_attributes }
            expect(response).to have_http_status(:unprocessable_entity)
          end
        end
      end
      
      context "when updating someone else's post" do
        let(:other_post) { Post.create!(description: "Post by another user", user: other_user) }
        
        it "does not update the post" do
          original_description = other_post.description
          put :update, params: { id: other_post.to_param, post: { description: "Trying to update someone else's post" } }
          other_post.reload
          expect(other_post.description).to eq(original_description)
        end
        
        it "redirects with an alert" do
          put :update, params: { id: other_post.to_param, post: { description: "Trying to update someone else's post" } }
          expect(response).to redirect_to(posts_path)
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "DELETE #destroy" do
      context "when deleting own post" do
        it "destroys the requested post" do
          post_instance = Post.create!(description: "Test post", user: user)
          expect {
            delete :destroy, params: { id: post_instance.to_param }
          }.to change(Post, :count).by(-1)
        end

        it "redirects to the posts list" do
          post_instance = Post.create!(description: "Test post", user: user)
          delete :destroy, params: { id: post_instance.to_param }
          expect(response).to redirect_to(posts_path)
        end
      end
      
      context "when deleting someone else's post" do
        let(:other_post) { Post.create!(description: "Post by another user", user: other_user) }
        
        it "does not destroy the post" do
          other_post # Ensure post is created before the expectation
          expect {
            delete :destroy, params: { id: other_post.to_param }
          }.not_to change(Post, :count)
        end
        
        it "redirects with an alert" do
          delete :destroy, params: { id: other_post.to_param }
          expect(response).to redirect_to(posts_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
  
  describe "authenticated user without organisation" do
    let(:user_without_org) {
      User.create!(
        name: "No Org User",
        email: "noorg@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active",
        organisation: nil
      )
    }
    
    before do
      session[:user_id] = user_without_org.id
    end
    
    describe "GET #index" do
      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
      
      it "only shows the user's own posts" do
        user_post = Post.create!(description: "My post", user: user_without_org)
        
        user_with_org = User.create!(
          name: "Org User",
          email: "org@example.com",
          password: "password123",
          password_confirmation: "password123",
          status: "active",
          organisation: organisation
        )
        other_post = Post.create!(description: "Other post", user: user_with_org)
        
        get :index
        expect(assigns(:posts)).to include(user_post)
        expect(assigns(:posts)).not_to include(other_post)
        expect(assigns(:no_organisation)).to be_truthy
      end
    end
    
    describe "GET #departed_posts" do
      it "returns a success response" do
        get :departed_posts
        expect(response).to be_successful
      end
      
      it "returns an empty array for departed posts" do
        get :departed_posts
        expect(assigns(:departed_posts)).to be_empty
        expect(assigns(:no_organisation)).to be_truthy
      end
    end
  end
end 