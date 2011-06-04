# == Schema Information
# Schema version: 20110602155816
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
#

class BacklogItem < ActiveRecord::Base
	attr_accessible :title, :points, :description, :position
	before_create :set_position

	belongs_to :backlog
	
	validates :backlog_id, :presence => true
	
	validates :title, :presence => true,
										:length => { :maximum => 200 }
										
	default_scope :order => "backlog_items.position ASC"
	
	def set_position()
		self.position = (self.backlog.backlog_items.maximum("position") || 0) + 1
	end
	
	def	is_allowed_to_delete(proposed_user)
		self.backlog.user == proposed_user
	end
	
	def is_allowed_to_edit(proposed_user)
		self.backlog.user == proposed_user
	end
end
