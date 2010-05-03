require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "register action" do
    should "be displayed" do
      get :register

      assert_response :success
      assert_jquery_datepicker_loaded
      assert_javascript_loaded 'register'
      assert_jquery_selectchain_loaded
    end
  end

  context "login action" do
    should "be displayed" do
      get :login

      assert_response :success
    end
  end

  context "logout action" do
    should "delete session user_id and redirect to main" do
      session[:typus_user_id] = 5
      get :logout
      assert_nil session[:typus_user_id]
      assert_redirected_to root_url
    end
  end
end
