require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  setup do
    @post = posts(:one)
    @user = users(:one)
    
    # Login
    visit login_url
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Login"
  end

  test "visiting the index" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "should create post" do
    visit posts_url
    click_on "New Post"

    fill_in "Description", with: "Test post description"
    select @user.primary_organisation.name, from: "Organisation"
    click_on "Create Post"

    assert_text "Post was successfully created"
    assert_text "Test post description"
  end

  test "should update Post" do
    visit post_url(@post)
    click_on "Edit", match: :first

    fill_in "Description", with: "Updated description"
    click_on "Update Post"

    assert_text "Post was successfully updated"
    assert_text "Updated description"
  end

  test "should destroy Post" do
    visit post_url(@post)
    click_on "Delete", match: :first
    
    page.driver.browser.switch_to.alert.accept

    assert_text "Post was successfully deleted"
  end
  
  test "filtering posts by organisation" do
    # First create a post in the user's primary org
    visit new_post_url
    fill_in "Description", with: "Post in org one"
    select organisations(:one).name, from: "Organisation"
    click_on "Create Post"
    
    # Join second org
    visit organisations_url
    within("#organisation_#{organisations(:two).id}") do
      click_on "Join"
    end
    
    # Create post in second org
    visit new_post_url
    fill_in "Description", with: "Post in org two"
    select organisations(:two).name, from: "Organisation"
    click_on "Create Post"
    
    # Go to posts index
    visit posts_url
    
    # Should see both posts
    assert_text "Post in org one"
    assert_text "Post in org two"
    
    # Filter by first org
    select organisations(:one).name, from: "organisation_id"
    click_on "Filter"
    
    # Should see only first post
    assert_text "Post in org one"
    assert_no_text "Post in org two"
    
    # Filter by second org
    select organisations(:two).name, from: "organisation_id"
    click_on "Filter"
    
    # Should see only second post
    assert_no_text "Post in org one"
    assert_text "Post in org two"
  end
  
  test "post organisation dropdown only shows user's organisations" do
    # Create a new org that user is not a member of
    other_org = Organisation.create!(name: "Not Member Org", country: "Test", language: "Test")
    
    visit new_post_url
    
    # Dropdown should have user's org
    assert_select "post[organisation_id]", options: [@user.primary_organisation.name]
    
    # But not the other org
    assert_no_select "post[organisation_id]", options: [other_org.name]
  end
end 