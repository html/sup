class AddCostTypeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :cost_type, :string
  end

  def self.down
    remove_column :events, :cost_type
  end
end
