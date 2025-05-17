require 'rails_helper'

RSpec.describe OrganisationsController, type: :controller do
  let(:valid_attributes) {
    { name: "Test Org", country: "USA", language: "English" }
  }

  let(:invalid_attributes) {
    { name: "", country: "USA", language: "English" }
  }

  describe "unauthenticated user" do
    it "redirects to login page" do
      get :index
      expect(response).to redirect_to(login_path)
    end
  end

  describe "authenticated user" do
    let(:user) {
      User.create!(
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
        password_confirmation: "password123",
        status: "active"
      )
    }

    before do
      # Simulate login by setting the session
      session[:user_id] = user.id
    end

    describe "GET #index" do
      it "returns a success response" do
        Organisation.create! valid_attributes
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        organisation = Organisation.create! valid_attributes
        get :show, params: { id: organisation.to_param }
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
        it "creates a new Organisation" do
          expect {
            post :create, params: { organisation: valid_attributes }
          }.to change(Organisation, :count).by(1)
        end

        it "redirects to the created organisation" do
          post :create, params: { organisation: valid_attributes }
          expect(response).to redirect_to(Organisation.last)
        end
      end

      context "with invalid params" do
        it "does not create a new organisation" do
          expect {
            post :create, params: { organisation: invalid_attributes }
          }.to_not change(Organisation, :count)
        end
        
        it "renders the new template with unprocessable entity status" do
          post :create, params: { organisation: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "POST #leave" do
      let(:organisation) { Organisation.create! valid_attributes }
      
      before do
        user.update(organisation: organisation)
        # Create some posts for the user
        Post.create!(description: "Test post 1", user: user)
        Post.create!(description: "Test post 2", user: user)
      end
      
      it "removes the user from the organisation" do
        post :leave, params: { id: organisation.to_param }
        user.reload
        expect(user.organisation).to be_nil
      end
      
      it "deletes all the user's posts" do
        expect {
          post :leave, params: { id: organisation.to_param }
        }.to change(Post, :count).by(-2)
      end
      
      it "redirects to root path" do
        post :leave, params: { id: organisation.to_param }
        expect(response).to redirect_to(root_path)
      end
    end
    
    describe "POST #join" do
      let(:organisation) { Organisation.create! valid_attributes }
      
      context "when user has no organisation" do
        before { user.update(organisation: nil) }
        
        it "adds the user to the organisation" do
          post :join, params: { id: organisation.to_param }
          user.reload
          expect(user.organisation).to eq(organisation)
        end
        
        it "redirects to the organisation" do
          post :join, params: { id: organisation.to_param }
          expect(response).to redirect_to(organisation)
        end
      end
      
      context "when user already belongs to an organisation" do
        let(:other_organisation) { Organisation.create!(name: "Other Org", country: "UK", language: "English") }
        
        before { user.update(organisation: other_organisation) }
        
        it "does not change the user's organisation" do
          post :join, params: { id: organisation.to_param }
          user.reload
          expect(user.organisation).to eq(other_organisation)
        end
        
        it "redirects to organisations path with alert" do
          post :join, params: { id: organisation.to_param }
          expect(response).to redirect_to(organisations_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end 