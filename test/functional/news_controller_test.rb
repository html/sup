require 'test_helper'

class NewsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  context "index action" do
    should "display truncated and stripped from tags description text" do
      Post.delete_all
      @text =  "<b>#{Faker::Lorem::sentence}</b><i>#{Faker::Lorem::sentence}</i>"
      @post = Post.make :content => @text
      get :index

      @view = @response.template

      assert_select '.section td.text_3', 1 do |t|
        assert t.first.children.first.to_s.match @view.truncate @view.strip_tags(@text), :length => 200
      end
    end
  end
  
  context "x" do
    should "y" do
      get :index

      assert_equal @response.template.t "asdf", "asdf"
    end
  end
end
