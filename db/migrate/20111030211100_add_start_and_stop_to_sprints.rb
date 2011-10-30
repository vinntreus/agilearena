class AddStartAndStopToSprints < ActiveRecord::Migration
  def self.up
  	add_column :sprints, :start, :datetime
  	add_column :sprints, :stop, :datetime
  end

  def self.down
   	remove_column :sprints, :start, :datetime
   	remove_column :sprints, :stop, :datetime
  end
end
