require 'test_helper'

class PostTest < ActiveSupport::TestCase
  context "Post::list" do
    should "return 5 items" do
      20.times do
        Post.make
      end

      assert_equal Post.list.size, 5
    end

    should "order by id DESC" do
      3.times do |i|
        Post.make :date => Date.today + (3 - i).hours
      end

      assert_equal Post.list.first, Post.last(:order => 'date')
    end

    should "return correct data for pages" do
      20.times do
        Post.make
      end

      assert_not_equal Post.list(1), Post.list(2)
    end
  end
end
