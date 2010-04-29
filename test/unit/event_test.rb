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
end
