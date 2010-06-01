require 'test_helper'

class TypusUserTest < ActiveSupport::TestCase
  should_validate_presence_of :login
  should_have_many :events
  should_belong_to :place
end
