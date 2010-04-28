class CreatePlaces < ActiveRecord::Migration
  def self.up
    create_table :places do |t|
      t.string :title
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table :places
  end
end
