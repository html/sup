require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "cities action" do
    should "return subcategories of some place" do
      @ev = Place.make :title => 'xxx'
      @child = Place.make :parent_id => @ev.id, :title => 'asdf'

      get :cities, :events => { :root_place => @ev.id }.stringify_keys

      obj = JSON.parse(@response.body)
      assert obj.is_a?(Array)
      assert_equal 1, obj.size
      assert_equal({ :label => 'asdf', :id => @child.id }.stringify_keys, obj.first)
    end

    should "return json array if no category exist" do
      Place.delete_all

      get :cities

      obj = JSON.parse(@response.body)
      assert obj.is_a?(Array)
      assert_equal 0, obj.size
    end

    context "with empty_text set" do
      setup do
        @default_object = { :label => 'Любой город', :id => 0 }.stringify_keys
      end

      should "return subcategories of some place" do
        @ev = Place.make :title => 'xxx'
        @child = Place.make :parent_id => @ev.id, :title => 'asdf'

        get :cities, :events => { :root_place => @ev.id }.stringify_keys, :empty_text => true

        obj = JSON.parse(@response.body)
        assert obj.is_a?(Array)
        assert_equal 2, obj.size
        assert_equal(
          [@default_object, { :label => 'asdf', :id => @child.id }.stringify_keys], 
          obj
        )
      end

      should "return json array if no category exist" do
        Place.delete_all

        get :cities, :empty_text => true

        obj = JSON.parse(@response.body)
        assert obj.is_a?(Array)
        assert_equal 1, obj.size
        assert_equal @default_object, obj.first
      end
    end
  end

  context "subjects action" do
    should "return subcategories of some place" do
      @ev = Subject.make :title => 'xxx'
      @child = Subject.make :parent_id => @ev.id, :title => 'asdf'

      get :subjects, :events => { :root_subject => @ev.id }.stringify_keys

      obj = JSON.parse(@response.body)
      assert obj.is_a?(Array)
      assert_equal 1, obj.size
      assert_equal({ :label => 'asdf', :id => @child.id }.stringify_keys, obj.first)
    end

    should "return json array if no category exist" do
      Place.delete_all

      get :subjects

      obj = JSON.parse(@response.body)
      assert obj.is_a?(Array)
      assert_equal 0, obj.size
    end

    context "with empty_text set" do
      setup do
        @default_object = { :label => 'Любая специализация', :id => 0 }.stringify_keys
      end

      should "return subcategories of some place with empty_text" do
        @ev = Subject.make :title => 'xxx'
        @child = Subject.make :parent_id => @ev.id, :title => 'asdf'

        get :subjects, :events => { :root_subject => @ev.id }.stringify_keys, :empty_text => true

        obj = JSON.parse(@response.body)
        assert obj.is_a?(Array)
        assert_equal 2, obj.size
        assert_equal(
          [@default_object, { :label => 'asdf', :id => @child.id }.stringify_keys], 
          obj
        )
      end

      should "return json array if no category exist" do
        Place.delete_all

        get :subjects, :empty_text => true 

        obj = JSON.parse(@response.body)
        assert obj.is_a?(Array)
        assert_equal 1, obj.size
        assert_equal @default_object, obj.first
      end
    end
  end

  context "index action" do
    should "contain titles" do
      Event.delete_all
      Event.make :title => 'xxx1<', :image_file_name => 'img1&lt;', :event_type_id => EventType.make(:title => 'secret title')
      Event.make :title => 'xxx2', :image_file_name => 'img2'

      get :index

      assert_jquery_datepicker_loaded
      #should contain titles
      assert_contains_n_times @response.body, 'xxx1&lt;', 1
      assert_contains_n_times @response.body, 'xxx2', 1
      #should contain links to items
      assert_contains_n_times @response.body, event_path(Event.first), 1
      assert_contains_n_times @response.body, event_path(Event.last), 1
      #should contain image links
      assert_contains_n_times @response.body, 'img1&lt;', 1
      assert_contains_n_times @response.body, 'img2', 1

      #should contain event_type
      assert_contains_n_times @response.body, 'secret title', 1
    end

    should "show 5 items per page" do
      Event.delete_all
      21.times do
        Event.make
      end

      get :index
      assert_select '.item', 5
      assert_correct_search_form_action
      assert_jquery_datepicker_loaded
      assert_javascript_loaded 'events-index'

      get :index, :page => 4
      assert_select '.item', 5
      assert_correct_search_form_action

      get :index, :page => 5
      assert_select '.item', 1
      assert_correct_search_form_action

      get :index, :page => 6
      assert_select '.item', 0
      assert_correct_search_form_action
    end

    should "show 5 items per page when from and to params given" do
      Event.delete_all
      21.times do
        Event.make :start_time => Date.today.to_datetime
      end

      p = { :from => (Date.today - 2.days).to_datetime, :to => (Date.today + 2.days).to_datetime }
      get :index, p
      assert_select '.item', 5
      assert_correct_search_form_action
      assert_jquery_datepicker_loaded
      assert_javascript_loaded 'events-index'

      get :index, p.merge(:page => 4)
      assert_select '.item', 5
      assert_correct_search_form_action

      get :index, p.merge(:page => 5)
      assert_select '.item', 1
      assert_correct_search_form_action

      get :index, p.merge(:page => 6)
      assert_select '.item', 0
      assert_correct_search_form_action
    end

    should "show pagination" do
      Event.delete_all
      20.times do
        Event.make
      end

      get :index
      assert_contains_pagination
      assert_jquery_datepicker_loaded
      assert_javascript_loaded 'events-index'
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

    should "show event dates" do
      Event.delete_all 
      Event.make :start_time => Date.new(1989, 05, 22).to_datetime
      Event.make :start_time => Date.new(1989, 05, 22).to_datetime, :end_time => Date.new(1989, 05, 22).to_datetime

      Event.make :start_time => Date.new(1941, 06, 22).to_datetime, :end_time => Date.new(1941, 06, 23).to_datetime
      Event.make :start_time => Date.new(1945, 05, 9).to_datetime, :end_time => Date.new(1945, 06, 01).to_datetime

      get :index

      assert_contains_n_times @response.body, '22 мая 1989 года', 2
      assert_contains_n_times @response.body, '22 - 23 июня 1941 года', 1
      assert_contains_n_times @response.body, '09 мая - 01 июня 1945 года', 1
    end

    should "contain events place" do
      Event.delete_all

      @place = Place.make :title => "Some big place<>"
      Event.make :place => @place

      get :index

      assert_contains_n_times @response.body,  "Some big place&lt;&gt;", 1
    end

    should "contain default string if no place given" do
      Event.delete_all
      Event.make :place => Place.make
      Event.update_all 'place_id' => nil

      get :index

      assert_contains_n_times @response.body,  "неизвестно", 1
    end
  end

  context "new action" do
    should "contain needed javascripts" do
      login
      get :new

      assert_jquery_datepicker_loaded
      assert_jquery_selectchain_loaded
      assert_javascript_loaded 'events'
    end
  end

  context "search action" do
    should "contain needed javascripts" do
      get :search

      assert_jquery_datepicker_loaded
      assert_jquery_selectchain_loaded
      assert_javascript_loaded 'events-search'
      assert_select 'form[action=?]', '/events/search'
    end

    should "call correct search method" do

      mock(Event).search(nil, 1, 3, 4, 2, 5, 6, nil, nil)
      get :search, :events => { :root_subject => 1, :root_place => 2  }, :event => { :subject_id => 3, :event_type_id => 4, :place_id => 5 }, :event_free => 6, :commit => true
    end
  end

  context "my action" do
    should "be displayed when logged in" do
      login
      get :my
      assert_response :success
    end

    should "act correctly when not logged in" do
      get :my
      assert_require_login
    end

    should "display message when no items added" do
      Event.delete_all
      login
      get :my

      assert_response_contains 'Не найдено событий по Вашему запросу.', 1
      assert_select "a[href=?]", new_event_path, { :count => 1, :text => "добавить событие" }
    end
  end

  context "protected methods" do
    should "correctly parse date" do
      get :index
      assert_equal Date.new(2010, 5, 7), @controller.send(:parse_date, '07.05.2010')
    end
  end
end
