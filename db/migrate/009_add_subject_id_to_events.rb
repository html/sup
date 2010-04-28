class AddSubjectIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :subject_id, :integer
  end

  def self.down
    remove_column :events, :subject_id
  end
end
