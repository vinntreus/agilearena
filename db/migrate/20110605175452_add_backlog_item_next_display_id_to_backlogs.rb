class AddBacklogItemNextDisplayIdToBacklogs < ActiveRecord::Migration
  def self.up
    add_column :backlogs, :backlog_item_next_display_id, :integer
  end

  def self.down
    remove_column :backlogs, :backlog_item_next_display_id
  end
end
