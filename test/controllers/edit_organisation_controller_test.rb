require "test_helper"

class EditOrganisationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organisation = organisations(:one)
    @user = users(:one)
    # Log in the user
    post login_path, params: { email: @user.email, password: 'password' }
  end
  
  test "should get edit page" do
    get edit_organisation_path(@organisation)
    assert_response :success
    assert_select "h1", "Edit Organisation"
    assert_select "form"
  end
  
  test "should update organisation with valid attributes" do
    patch organisation_path(@organisation), params: { 
      organisation: { 
        name: "Updated Organisation", 
        country: "Updated Country", 
        language: "Updated Language" 
      } 
    }
    
    assert_redirected_to organisation_path(@organisation)
    assert_equal "Organisation was successfully updated.", flash[:notice]
    
    @organisation.reload
    assert_equal "Updated Organisation", @organisation.name
    assert_equal "Updated Country", @organisation.country
    assert_equal "Updated Language", @organisation.language
  end
  
  test "should not update organisation with invalid attributes" do
    patch organisation_path(@organisation), params: { 
      organisation: { 
        name: "", # Invalid: name is required
        country: "Updated Country", 
        language: "Updated Language" 
      } 
    }
    
    assert_response :unprocessable_entity
    assert_select "div.alert.alert-error"
    
    @organisation.reload
    assert_not_equal "", @organisation.name
  end
  
  test "should redirect to organisation after successful update" do
    patch organisation_path(@organisation), params: { 
      organisation: { 
        name: "Redirected Organisation", 
        country: "Redirected Country", 
        language: "Redirected Language" 
      } 
    }
    
    assert_redirected_to organisation_path(@organisation)
    follow_redirect!
    
    assert_select "h1", "Redirected Organisation"
    assert_select "div.text-foreground", "Redirected Country"
    assert_select "div.text-foreground", "Redirected Language"
  end
end 