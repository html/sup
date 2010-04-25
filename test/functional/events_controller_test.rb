require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  context "index action" do
    should "contain titles" do
      Event.delete_all
      Event.make :title => 'xxx1', :image_file_name => 'img1'
      Event.make :title => 'xxx2', :image_file_name => 'img2'

      get :index

      #should contain titles
      assert_contains_n_times @response.body, 'xxx1', 1
      assert_contains_n_times @response.body, 'xxx2', 1
      #should contain links to items
      assert_contains_n_times @response.body, event_path(Event.first), 1
      assert_contains_n_times @response.body, event_path(Event.last), 1
      #should contain image links
      assert_contains_n_times @response.body, 'img1', 1
      assert_contains_n_times @response.body, 'img2', 1
    end

    should "show 5 items per page" do
      Event.delete_all
      20.times do
        Event.make
      end

      get :index

      assert_select '.item', 5
    end

    should "show pagination" do
      Event.delete_all
      20.times do
        Event.make
      end

      get :index
      assert_contains_pagination
    end

    should "show correct message if cost is zero" do
      Event.delete_all
      Event.make :cost => nil
      
      get :index

      assert_contains_n_times @response.body, "666666", 0
      assert_contains_n_times @response.body, "Бесплатное посещение", 1
    end

    should "show cost for each item" do
      Event.delete_all
      Event.make :cost => 666666

      get :index

      assert_contains_n_times @response.body, "666666", 1
      assert_contains_n_times @response.body, "Бесплатное посещение", 0
    end
  end
end
