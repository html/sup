class NewsController < ApplicationController
  def index
    flash[:notice] = 'test'
    @news = Post.list(params[:page])
  end

  def show
    @item = Post.find(params[:id])
  end
end
