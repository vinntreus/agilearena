# == Schema Information
# Schema version: 20110515152639
#
# Table name: backlogs
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Backlog < ActiveRecord::Base
	attr_accessible :title

	belongs_to :user	
	
	validates :user_id, :presence => true
	validates :title, :presence => true,
										:length => { :maximum => 100 }
	
	default_scope :order => "backlogs.created_at DESC"
end
