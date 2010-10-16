class AddUrlToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :url, :string
  end

  def self.down
    remove_column :books, :url
  end
end
