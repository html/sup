class NewsController < ApplicationController
  def index
    @news = Post.paginate :page => params[:page], :per_page => 5
  end

  def show
    @item = Post.find(params[:id])
  end
end
