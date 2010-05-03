require 'test_helper'
require 'typus_user_ext'

class TypusUserTest < ActiveSupport::TestCase
  should_validate_presence_of :login
  should_have_many :events
end
