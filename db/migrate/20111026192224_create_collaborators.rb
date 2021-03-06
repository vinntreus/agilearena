class CreateCollaborators < ActiveRecord::Migration
  def self.up
    create_table :collaborators do |t|
      t.integer :user_id
      t.integer :backlog_id
      t.string :role

      t.timestamps
    end
    
    add_index :collaborators, :backlog_id
    add_index :collaborators, :user_id
  end

  def self.down
    remove_index :collaborators, :backlog_id
    remove_index :collaborators, :user_id
    
    drop_table :collaborators
  end
end
