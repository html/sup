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
      assert_not_nil assigns(:places)
      assert_not_nil assigns(:subjects)
    end
  end

  context "login action" do
    should "be displayed" do
      get :login

      assert_response :success
    end

    should "output link to forgot_password page when wrong password provided" do
      post :login, :typus_user => {}

      assert_response :success

      assert_contains_n_times @response.body, forgot_password_path, 1
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
      assert_redirected_to root_url
    end
  end

  context "profile action" do
    should "be displayed" do
      @xss_data = xss_array(:login, :first_name, :last_name, :patronymic)
      @city = Place.make(
        xss_array(:title).merge(:parent_id => Place.make(xss_array(:title)).id)
      )
      @user = TypusUser.make @xss_data.merge(:place_id => @city.id)
      login

      get :profile, :id => @user.id

      assert_not_nil assigns(:user)
      assert_response_contains '&lt;login&gt;', 1
      assert_response_contains '&lt;first_name&gt;', 1
      assert_response_contains '&lt;last_name&gt;', 1
      assert_response_contains '&lt;patronymic&gt;', 1
      assert_response_contains '&lt;title&gt;', 2
      assert_select 'img.avatar', :count => 2
    end

    should "display edit profile message if user watches his profile" do
      login

      get :profile, :id => @current_user.id
      
      assert_response_contains 'Редактировать профиль', 1
    end
  end

  context "change_status action" do
    should "be displayed" do
      get :change_status
      assert_require_login
    end

    should "display buy message" do
      login

      get :change_status
      
      assert_response_contains 'Купить', 1
    end

    should "change user's status" do
      login

      get :change_status, :status => :partner

      assert_equal 'partner', @current_user.reload.role
      assert_redirected_to change_status_path
    end

    should "behave correctly when user is partner" do
      login
      @current_user.update_attributes :role => "partner"

      get :change_status
      assert_response_contains 'Купить', 0
      assert_response_contains 'Переключиться на мастера', 1
      assert_response_contains 'Переключиться на партнера', 0
    end

    should "behave correctly when user is master" do
      login
      @current_user.update_attributes :role => "master"

      get :change_status
      assert_response_contains 'Купить', 0
      assert_response_contains 'Переключиться на мастера', 0
      assert_response_contains 'Переключиться на партнера', 1
    end
  end

  context "profile_edit action" do
    should "require login" do
      get :edit_profile
      assert_require_login
    end

    should "contain link to change_password" do
      login
      get :edit_profile

      assert_select "a[href=?][target=_blank]", change_path, { :count => 1, :text => "Изменить пароль" }
    end

    should "contain form and correct form fields" do
      login
      @current_user.update_attributes :login => 'xxxxxxxxxxxxxxxx'
      get :edit_profile

      assert_jquery_selectchain_loaded
      assert_jquery_datepicker_loaded

      assert_contains_n_times @response.body, 'xxxxxxxxxxxxxxxx', 2

      assert_select 'form[method=post][action=?]', edit_profile_path, :count => 1 do|tag|
        #text
        assert_contains_edit_fields :first_name, :last_name, :patronymic, :birth_date, :ways, :phone_number, :icq, :site, :for => :typus_user

        #place
        assert_contains_select_fields :place_id, :for => :typus_user
        assert_contains_select_fields :root_place, :for => :events

        assert_select 'textarea[name=?]', 'typus_user[about]'
        assert_select 'input[type=file][name=?]', 'typus_user[avatar]'
        assert_select tag[0], 'img.avatar'
      end
    end
  end
end
