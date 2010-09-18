class CommonController < ApplicationController
  def faq
    
  end
  
  def materials
    @materials = Material.all
  end
end
