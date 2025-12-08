require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get sign up page" do
    get signup_path
    assert_response :success
    assert_select "h2", "Create Account" # Checks if the header exists
  end

  test "should create user with valid attributes" do
    # Verify that User and UserProfile count increases by 1
    assert_difference -> { User.count } => 1, -> { UserProfile.count } => 1 do
      post signup_path, params: {
        user: {
          email: "test_unit@example.com",
          password: "password123",
          password_confirmation: "password123",
          user_profile_attributes: {
            first_name: "Florence",
            middle_initial: "N",
            last_name: "Nightingale",
            city: "London",
            state: "UK"
          }
        }
      }
    end

    # Follow the redirect to root (dashboard)
    assert_redirected_to root_path
    follow_redirect!

    # Check flash message
    assert_equal "Welcome, Florence!", flash[:notice]
  end

  test "should not create user with invalid attributes" do
    # Verify that counts do NOT change
    assert_no_difference [ "User.count", "UserProfile.count" ] do
      post signup_path, params: {
        user: {
          email: "", # Invalid: empty email
          password: "password123",
          user_profile_attributes: {
            first_name: "Florence"
          }
        }
      }
    end

    # Should re-render the 'new' template with unprocessable_entity status (422)
    assert_response :unprocessable_entity
    assert_template :new
  end
end
