class CreateSprints < ActiveRecord::Migration
  def self.up
    create_table :sprints do |t|
	    t.integer :backlog_id
      t.string :title

      t.timestamps     
    end
    
    add_index :sprints, :backlog_id
  end

  def self.down
    drop_table :sprints
  end
end
