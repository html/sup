require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  def assert_contains_materials_menu
    assert_select '#materials_menu', :count => 1
  end
  # Replace this with your real tests.
  context "show_material action" do
    should "have correct route" do
      assert_generates '/material/1', :controller => :common, :action => :show_material, :id => 1
    end

    should "show material successfully" do
      get :show_material, :id => Material.make

      assert_response :success
      assert_contains_materials_menu
    end

    context "Book material" do
      setup do
        @material = Material.make :item_id => Book.make(:url => "http://xxxx").id, :item_type => "Book", :info => "Some info"
      end

      should "show link to book, image of book" do
        get :show_material, :id => @material.id

        assert_select 'a[href=?][target=_blank]', @material.item.url
        assert_select 'img[src=?]', @material.item.file.url
        assert_response_contains 'Some info', 1
      end
    end

    context "Video material" do
      setup do
        @material = Material.make :item_id => Video.make(:code => "some unique code with <tags>").id, :item_type => "Video", :info => "Some info"
      end

      should "show item code" do
        get :show_material, :id => @material.id

        assert_response_contains "some unique code with <tags>", 1
        assert_response_contains 'Some info', 1
      end
    end
  end

  context "video_materials action" do
    should "have correct route" do
      assert_generates '/materials/video', :controller => :common, :action => :video_materials
    end

    should "respond correctly" do
      get :video_materials

      assert_response :success
      assert_contains_materials_menu
    end
  end
    
  context "book_materials action" do
    should "have correct route" do
      assert_generates '/materials/books', :controller => :common, :action => :book_materials
    end

    should "respond correctly" do
      get :book_materials

      assert_response :success
    end
  end
end
