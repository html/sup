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
    @materials = Material.find_all_by_item_type(:book)

    render :action => :materials
  end

  def video_materials
    @materials = Material.find_all_by_item_type(:video)

    render :action => :materials
  end
end
