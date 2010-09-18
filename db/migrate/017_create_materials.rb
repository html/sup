class CreateMaterials < ActiveRecord::Migration
  def self.up
    create_table :materials do |t|
      t.string :title
      t.string :original_title
      t.string :item_type
      t.integer :item_id

      t.timestamps
    end
  end

  def self.down
    drop_table :materials
  end
end
