ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'
require 'machinist/active_record'
require 'ruby-debug'
require 'faker'
require 'rr'

Event.blueprint do
  title 'test'
  content 'xxx'
  cost 123
  start_time Date.today.to_datetime
  place_id Place.make.id
  subject_id Subject.make.id
  event_type_id EventType.make.id
  owner_id TypusUser.make.id
end

Post.blueprint do
  title 'test'
  content 'xxx'
  date Date.today.to_datetime
end

Place.blueprint do
  title 'asdf'
end

Subject.blueprint do
  title 'asdf'
end

EventType.blueprint do
  title 'asdf'
end

TypusUser.blueprint do |x,y|
  email Faker::Internet.email
  password 'x' * 8
  role 'user'
  login Faker::Name.name + rand(100).to_s
end

class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def assert_contains_n_times(str1, str2, num)
    assert_equal num,str1.scan(str2).size
  end

  def assert_response_contains(str, num)
    assert_contains_n_times @response.body, str, num
  end

  def assert_contains_pagination
    assert_select '#pagination'
  end

  def assert_correct_search_form_action
    assert_select "form#form_with_navigation[action=?][method=get]", events_path
  end
  
  def assert_jquery_datepicker_loaded
    assert_css_loaded '/css/base/ui.all.css'
    assert_javascript_loaded 'ui/ui.core'
    assert_javascript_loaded 'ui/ui.datepicker'
    assert_javascript_loaded 'ui/i18n/ui.datepicker-ru'
  end

  def assert_javascript_loaded(js)
    str =  "/javascripts/#{js}.js"
    assert_select 'script[type=text/javascript][src^=?]', str, 1
  end
  
  def assert_css_loaded(css)
    assert_select 'link[type=text/css][href^=?]', css, 1
  end

  def assert_jquery_selectchain_loaded
    assert_javascript_loaded 'jquery.selectchain'
    assert_javascript_loaded 'apply-select-chain'
  end

  def assert_require_login
    assert_redirected_to root_url
  end

  def login
    session[:typus_user_id] = (@current_user ||= TypusUser.make).id
  end
end
