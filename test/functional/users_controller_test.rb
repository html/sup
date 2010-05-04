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
      login
      get :logout
      assert_nil session[:typus_user_id]
      assert_redirected_to root_url
    end

    should "require login" do
      get :logout
      assert_require_login
    end
  end

  context "change password action" do
    should "be visible when logged in" do
      login
      get :change_password
      assert_response :success
    end

    should "redirect when changed password" do
      login

      post :change_password, :typus_user => { :password => 'x' * 8, :password_confirmation => 'x' * 8 }
      assert_redirected_to root_url
    end

    should "not redirect when password_confirmation missing" do
      login
      
      post :change_password, :typus_user => { :password => 'x' * 12 }
      assert_response :success
    end

    should "not redirect when password_confirmation is incorrect" do
      login
      
      post :change_password, :typus_user => { :password => 'x' * 8, :password_confirmation => 'x' * 9 }
      assert_response :success
    end

    should "require login" do
      get :change_password
      assert_require_login
    end


    context "recovering password" do
      should "allow user to change password by recovery hash while not logged in" do
        hash = 'NotARealHashYet'
        TypusUser.make :recovery_hash => hash

        get :change_password, :recover => hash
        assert_response :success
      end

      should "not allow user to change password when wrong recover hash specified" do
        TypusUser.delete_all
        get :change_password, :recover => ""
        assert_redirected_to forgot_password_url
      end

      should "redirect when changed password" do
        @user = TypusUser.make :recovery_hash => "asdf"
        post :change_password, :typus_user => { :password => 'x' * 8, :password_confirmation => 'x' * 8 }, :recover => 'asdf'
        assert_equal 'x' * 8, @user.password
        assert_redirected_to root_url
      end
    end
  end

  context "forgot_password action" do
    should "be displayed" do
      get :forgot_password
      assert_response :success
    end

    should "update recovery hash for user with specified email" do
      @user = TypusUser.make

      @request.env['HTTP_HOST'] = 'localhost'
      assert_nil @user.recovery_hash
      post :forgot_password, :typus_user => { :email => @user.email }
      assert_not_nil @user.reload.recovery_hash
    end
  end
end
