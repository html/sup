class AddAttachmentsAvatarToTypusUser < ActiveRecord::Migration
  def self.up
    add_column :typus_users, :avatar_file_name, :string
    add_column :typus_users, :avatar_content_type, :string
    add_column :typus_users, :avatar_file_size, :integer
    add_column :typus_users, :avatar_updated_at, :datetime
  end

  def self.down
    remove_column :typus_users, :avatar_file_name
    remove_column :typus_users, :avatar_content_type
    remove_column :typus_users, :avatar_file_size
    remove_column :typus_users, :avatar_updated_at
  end
end
