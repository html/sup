class CommonController < ApplicationController
  def faq
    
  end
  
  def materials
    @materials = Material.all
  end

  def show_material
    @material = Material.find(params[:id])
  end

  def book_materials
    @materials = Material.find_all_by_item_type("Book")
    @for = 'book'

    render :action => :materials
  end

  def video_materials
    @materials = Material.find_all_by_item_type("Video")
    @for = 'video'

    render :action => :materials
  end

  def materials_by_letter
    @letter = params[:letter]
    if params[:for] == 'all'
      @materials = Material.title_begins_with(params[:letter])
    else
      @materials = Material.item_type_equals_and_title_begins_with(params[:letter])
    end

    render :action => :materials
  end
end
