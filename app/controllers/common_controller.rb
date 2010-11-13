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

    render :action => :materials
  end

  def video_materials
    @materials = Material.find_all_by_item_type("Video")

    render :action => :materials
  end

  def materials_by_letter
    @letter = params[:letter]
    @materials = Material.title_begins_with(params[:letter])

    render :action => :materials
  end
end
