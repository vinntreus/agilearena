class AddStatusToBacklogItems < ActiveRecord::Migration
  def self.up
		add_column :backlog_items, :status, :string, :default => "Todo"
  end

  def self.down
 		remove_column :backlog_items, :status
  end
end
