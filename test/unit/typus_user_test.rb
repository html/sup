require 'test_helper'

class TypusUserTest < ActiveSupport::TestCase
  should_validate_presence_of :login
  should_have_many :events
  should_belong_to :place

  context "#masters" do
    should "return masters with page" do
      5.times { TypusUser.make :role => 'partner' }
      9.times { TypusUser.make :role => 'master' }

      @masters = TypusUser.masters(1)
      @masters2 = TypusUser.masters(2)

      assert_equal 5, @masters.size
      assert_equal 4, @masters2.size
    end
  end

  context "#activated?" do
    should "return false if activation_code is not empty" do
      @user = TypusUser.make
      @user.activation_code = 'asdf'
      assert !@user.activated?
    end

    should "return true if activation_code is empty" do
      @user = TypusUser.make
      @user.activation_code = nil
      assert @user.activated?
    end
  end

  context "#make_activated" do
    should "set activation_code to nil" do
      @user = TypusUser.make
      @user.generate_activation_code
      @user.save!

      assert !@user.activated?
      @user.make_activated
      assert @user.activated?
    end
  end
end
