class Place < ActiveRecord::Base
  #acts_as_list
  acts_as_tree

  def typus_name
    title
  end

  def xxx
    if parent_id
      '↳'
    else
      '*'
    end
  end
end
