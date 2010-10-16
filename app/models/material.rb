class Material < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  def self.count_by_first_letter(letter)
    return true unless title_begins_with(letter).empty?
  end
end
