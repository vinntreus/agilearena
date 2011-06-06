# == Schema Information
# Schema version: 20110605181027
#
# Table name: backlogs
#
#  id                           :integer         not null, primary key
#  title                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  user_id                      :integer
#  private                      :boolean
#  backlog_item_next_display_id :integer
#

class Backlog < ActiveRecord::Base	
	attr_accessible :title, :private
	before_create :init_display_id
	
  acts_as_tagger

	
	POINTS = [1, 2, 3, 5, 8, 13, 20, 40, 100]

	belongs_to :user	
	has_many :backlog_items, :dependent => :destroy
	
	validates :user_id, :presence => true
	validates :title, :presence => true,
										:length => { :maximum => 100 }
	
	default_scope :order => "backlogs.created_at DESC"
	
	def init_display_id
		self.backlog_item_next_display_id = 1
	end
	
	def self.sort_items(current_item, new_parent_id)
		@current_item = current_item #BacklogItem.find(id)		
		@current_position = @current_item.position

		if new_parent_id < 1						
			put_item_on_top @current_item
		else		
			@new_parent = BacklogItem.find(new_parent_id)				
			@parent_position = @new_parent.position		

			if(@parent_position < @current_position)
				sort_downwards @current_item, @parent_position	
			else
				sort_upwards @current_item, @parent_position
			end

		end
		
		@current_item.save
	end
	
	private 
		def self.put_item_on_top(current_item)
			BacklogItem.update_all("position = position + 1", ["position < ?", current_item.position] , :backlog_id => current_item.backlog_id)
			current_item.position = 1
		end
		def self.sort_downwards(current_item, parent_position)
			BacklogItem.update_all("position = position + 1", 
																:position => (parent_position + 1)..current_item.position, 
																:backlog_id => current_item.backlog_id)
			current_item.position = parent_position + 1
		end
		def self.sort_upwards(current_item, parent_position)
			BacklogItem.update_all("position = position - 1", 
																:position => current_item.position..(parent_position),
																:backlog_id => current_item.backlog_id)
			current_item.position = parent_position
		end

end
