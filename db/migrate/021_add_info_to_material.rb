class AddInfoToMaterial < ActiveRecord::Migration
  def self.up
    add_column :materials, :info, :text
  end

  def self.down
    remove_column :materials, :info
  end
end
