class AddDisplayIdToBacklogItems < ActiveRecord::Migration
  def self.up
    add_column :backlog_items, :display_id, :integer
  end

  def self.down
    remove_column :backlog_items, :display_id
  end
end
