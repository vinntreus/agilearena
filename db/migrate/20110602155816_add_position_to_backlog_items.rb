class AddPositionToBacklogItems < ActiveRecord::Migration
  def self.up
    add_column :backlog_items, :position, :int
  end

  def self.down
    remove_column :backlog_items, :position
  end
end
