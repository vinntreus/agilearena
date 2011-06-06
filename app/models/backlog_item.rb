# == Schema Information
# Schema version: 20110605181027
#
# Table name: backlog_items
#
#  id          :integer         not null, primary key
#  backlog_id  :integer
#  title       :string(255)
#  points      :integer
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  position    :integer
#  display_id  :integer
#

class BacklogItem < ActiveRecord::Base
	attr_accessible :title, :points, :description, :position
	before_create :set_position, :set_display_id

	belongs_to :backlog
	
	validates :backlog_id, :presence => true
	
	validates :title, :presence => true,
										:length => { :maximum => 200 }
										
	default_scope :order => "backlog_items.position ASC"
	
	def set_position()
		self.position = (self.backlog.backlog_items.maximum("position") || 0) + 1
	end
	
	def set_display_id
		self.display_id = self.backlog.backlog_item_next_display_id
		self.backlog.increment!(:backlog_item_next_display_id)
	end	
end
