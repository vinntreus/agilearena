class AddUsersToBacklogs < ActiveRecord::Migration
  def self.up
    add_column :backlogs, :user_id, :integer
    add_index :backlogs, :user_id
  end

  def self.down
    remove_index :backlogs, :user_id
    remove_column :backlogs, :user_id    
  end
end
