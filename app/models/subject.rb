class Subject < ActiveRecord::Base
  acts_as_tree

  def typus_name
    title
  end
end
