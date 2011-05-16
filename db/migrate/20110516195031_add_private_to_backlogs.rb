class AddPrivateToBacklogs < ActiveRecord::Migration
  def self.up
    add_column :backlogs, :private, :boolean, :default => false
  end

  def self.down
    remove_column :backlogs, :private
  end
end
