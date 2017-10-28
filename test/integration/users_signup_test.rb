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
end
