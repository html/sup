class Material < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
end
