class AddPatronymicAndBirthDateToTypusUsers < ActiveRecord::Migration
  def self.up
    add_column :typus_users, :patronymic, :string
    add_column :typus_users, :birth_date, :date
    add_column :typus_users, :login, :string
    add_column :typus_users, :city_id, :integer
  end

  def self.down
    remove_column :typus_users, :birth_date
    remove_column :typus_users, :patronymic
    remove_column :typus_users, :login
    remove_column :typus_users, :city_id
  end
end
