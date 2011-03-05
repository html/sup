require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should_have_db_columns :title, :content
  should_validate_presence_of :title, :content
  should_validate_numericality_of :cost
  should_validate_presence_of :start_time
  should_validate_presence_of :place_id, :subject_id, :event_type
  should_ensure_length_in_range :title, 0..150
  should_belong_to :place
  should_belong_to :subject
  should_belong_to :event_type
  should_belong_to :owner
  should_validate_presence_of :owner_id
  should_validate_presence_of :cost_type
  should_allow_values_for :cost_type, 'usd', 'eur', 'uah'
  should_not_allow_values_for :cost_type, 'usd1', 'eur2', 'uah3', 'xxx'

  context "Event::last_event_date" do
    should "return correct date" do
      last_date = Date.today + 3.hours
      Event.delete_all 
      Event.make :start_time => last_date
      Event.make :start_time => Date.today + 2.hours

      assert_equal Event.last_event_date, last_date
    end
  end

  context "Event::all_in_range" do
    should "return correct data" do
      Event.make :start_time => (Date.today - 2.days).to_datetime
      Event.make :start_time => (Date.today + 2.days).to_datetime
      @ev = Event.make :start_time => (Date.today).to_datetime
      assert_equal [@ev], Event.all_in_range((Date.today - 1.day).to_datetime, Date.tomorrow.to_datetime)
    end

    should "return 5 items" do
      Event.delete_all
      21.times do
        Event.make :start_time => Date.today.to_datetime
      end

      start = (Date.today - 1.day).to_datetime
      _end = (Date.today + 1.day).to_datetime

      assert_equal 5, Event.all_in_range(start, _end, 1).size
      assert_equal 5, Event.all_in_range(start, _end, 4).size
      assert_equal 1, Event.all_in_range(start, _end, 5).size
      assert_equal 0, Event.all_in_range(start, _end, 6).size
    end
  end

  context "Event::search" do
    should "return all items when no params" do
      Event.delete_all 
      6.times do
        Event.make 
      end

      assert_equal 5, Event.search.size
      assert_equal 1, Event.search(2).size
    end

    should "return only items with specified subject parent_id" do
      Event.delete_all 
      rand(5).times do
        Event.make 
      end

      @subject = Subject.make :parent_id => Subject.make.id
      @event = Event.make :subject_id => @subject.id

      assert_equal [@event], Event.search(nil, @subject.parent_id)
    end


    should "return only items with specified subject_id" do
      Event.delete_all 
      rand(5).times do
        Event.make 
      end

      @subject = Subject.make
      @event = Event.make :subject_id => @subject.id

      assert_equal [@event], Event.search(nil, nil, @subject.id)
    end

    should "return only items with specified event_type_id" do
      Event.delete_all 
      rand(5).times do
        Event.make 
      end

      @subject = EventType.make
      @event = Event.make :event_type_id => @subject.id

      assert_equal [@event], Event.search(nil, nil, nil, @subject.id)
    end

    should "return only items with specified place_parent_id" do
      Event.delete_all 
      rand(5).times do
        Event.make 
      end

      @place = Place.make :parent_id => Place.make.id
      @event = Event.make :place_id => @place.id

      assert_equal [@event], Event.search(nil, nil, nil, nil, @place.parent_id)
    end

    should "return only items with specified place_id" do
      Event.delete_all 
      rand(5).times do
        Event.make 
      end

      @place = Place.make
      @event = Event.make :place_id => @place.id

      assert_equal [@event], Event.search(nil, nil, nil, nil, nil, @place.id)
    end

    should "return all items" do
      Event.delete_all 
      2.times do
        Event.make :cost => 5
      end

      1.times do
        Event.make :cost => 0
      end

      1.times do
        Event.make :cost => nil
      end

      assert_equal 4, Event.search(nil, nil, nil, nil, nil, nil, 0).size
    end

    should "return only free items" do
      Event.delete_all 
      3.times do
        Event.make :cost => 5
      end

      2.times do
        Event.make :cost => 0
      end

      2.times do
        Event.make :cost => nil
      end

      assert_equal 4, Event.search(nil, nil, nil, nil, nil, nil, 1).size
    end

    should "return only non-free items" do
      Event.delete_all 
      3.times do
        Event.make :cost => 1
      end

      2.times do
        Event.make :cost => 0
      end

      2.times do
        Event.make :cost => nil
      end

      assert_equal 3, Event.search(nil, nil, nil, nil, nil, nil, 2).size
    end

    should "return only items that start after some time" do
      Event.delete_all 
      3.times do
        Event.make :start_time => Date.today.to_datetime
      end

      2.times do
        Event.make :start_time => (Date.today + 1.day).to_datetime
      end

      assert_equal 2, Event.search(nil, nil, nil, nil, nil, nil, nil, Date.today + 1.day).size
    end

    should "return only items that start before some time" do
      Event.delete_all 
      3.times do
        Event.make :start_time => (Date.today - 1.day).to_datetime
      end

      2.times do
        Event.make :start_time => (Date.today + 1.day).to_datetime
      end

      assert_equal 3, Event.search(nil, nil, nil, nil, nil, nil, nil, nil, Date.today.to_datetime).size
    end
  end
end
