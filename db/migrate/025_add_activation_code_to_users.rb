class AddActivationCodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :typus_users, :activation_code, :string
  end

  def self.down
    remove_column :typus_users, :activation_code
  end
end
