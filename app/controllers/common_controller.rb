class CommonController < ApplicationController
  def faq
    
  end
  
  def materials
    @materials = Material.all
  end

  def show_material
    @material = Material.find(params[:id])
  end
end
