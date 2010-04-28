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
end
