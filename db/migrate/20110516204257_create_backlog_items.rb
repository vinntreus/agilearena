class CreateBacklogItems < ActiveRecord::Migration
  def self.up
    create_table :backlog_items do |t|
      t.integer :backlog_id
      t.string :title
      t.integer :points
      t.string :description

      t.timestamps          
    end
    
    add_index :backlog_items, :backlog_id
  end

  def self.down
    drop_table :backlog_items
  end
end
