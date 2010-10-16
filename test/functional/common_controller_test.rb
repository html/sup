require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "show_material action" do
    should "have correct route" do
      assert_generates '/material/1', :controller => :common, :action => :show_material, :id => 1
    end

    should "show material successfully" do
      get :show_material, :id => Material.make

      assert_response :success
    end

    context "Book material" do
      setup do
        @material = Material.make :item_id => Book.make(:url => "http://xxxx").id, :item_type => "Book"
      end

      should "show link to book, image of book" do
        get :show_material, :id => @material.id

        assert_select 'a[href=?][target=_blank]', @material.item.url
        assert_select 'img[src=?]', @material.item.file.url
      end
    end

    context "Video material" do
      setup do
        @material = Material.make :item_id => Video.make(:code => "some unique code with <tags>").id, :item_type => "Video"
      end

      should "show item code" do
        get :show_material, :id => @material.id

        assert_response_contains "some unique code with <tags>", 1
      end
    end
  end
end
