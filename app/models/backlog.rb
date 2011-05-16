# == Schema Information
# Schema version: 20110516195031
#
# Table name: backlogs
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  private    :boolean
#

class Backlog < ActiveRecord::Base
	attr_accessible :title, :private

	belongs_to :user	
	has_many :backlog_items, :dependent => :destroy
	
	validates :user_id, :presence => true
	validates :title, :presence => true,
										:length => { :maximum => 100 }
	
	default_scope :order => "backlogs.created_at DESC"
end
