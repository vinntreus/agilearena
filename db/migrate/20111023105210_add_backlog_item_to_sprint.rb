class AddBacklogItemToSprint < ActiveRecord::Migration
  def self.up
  	add_column :backlog_items, :sprint_id, :integer
    add_index :backlog_items, :sprint_id
  end

  def self.down
   	remove_column :backlog_items, :sprint_id
    remove_index :backlog_items, :sprint_id
  end
end
