class AddRecoveryHashToTypusUsers < ActiveRecord::Migration
  def self.up
    add_column :typus_users, :recovery_hash, :string
  end

  def self.down
    remove_column :typus_users, :recovery_hash
  end
end
