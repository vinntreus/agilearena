class Sprint < ActiveRecord::Base
	attr_accessible :title
	before_create :set_title
	
	belongs_to :backlog
	has_many :backlog_items
	
	def set_title
		if self.title.nil?
	    self.title = (self.backlog.sprints.count + 1).to_s
	  end
	end
	
	def display_title
		if self.title.nil?
			logger.info("SPRINT:display_title is null for sprint-id = #{self.id}")
			return self.title
		end
		
		if self.title.is_number?
			return "Sprint ##{self.title}"
		end
		
		return self.title
	end	
	
end
