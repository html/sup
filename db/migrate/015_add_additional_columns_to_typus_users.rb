class AddAdditionalColumnsToTypusUsers < ActiveRecord::Migration
  def self.up
    add_column :typus_users, :sex, :boolean
    add_column :typus_users, :ways, :string
    add_column :typus_users, :phone_number, :string
    add_column :typus_users, :place_id, :integer
    add_column :typus_users, :icq, :string
    add_column :typus_users, :site, :string
    add_column :typus_users, :about, :text
  end

  def self.down
    remove_column :typus_users, :sex
    remove_column :typus_users, :ways
    remove_column :typus_users, :phone_number
    remove_column :typus_users, :place_id
    remove_column :typus_users, :site
    remove_column :typus_users, :about
  end
end
