require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
  end

  test "empty name" do
    get signup_path
    post users_path, params: { user: { name:  "",
                                       email: "",
                                       password:              "foo",
                                       password_confirmation: "bar" } }
    assert_select "div#error_explanation li", "Name can't be blank"
    assert_select "div#error_explanation li", "Email can't be blank"
    assert_select "div#error_explanation li", "Email is invalid"
    assert_select "div#error_explanation li", "Password confirmation doesn't match Password"
    assert_select "div#error_explanation li", "Password is too short (minimum is 6 characters)"
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Valid",
                                         email: "valid@valid-email.com",
                                         password: "foobar",
                                         password_confirmation: "foobar"}}
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash[:success] == "Welcome to the Sample App!"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" }}
    end
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
