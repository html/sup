class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :title
      t.integer :category_id
      t.datetime :start_time
      t.datetime :end_time
      t.text :content
      t.integer :cost

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
