class Sprint < ActiveRecord::Base
	attr_accessible :title, :start, :stop
	before_create :set_title, :set_stop
	
	belongs_to :backlog
	has_many :backlog_items
	
	default_scope :order => "sprints.start ASC"
	
	def set_title
		if self.title.nil?
	    self.title = (self.backlog.sprints.count + 1).to_s
	  end
	end
	
	def set_stop
		self.stop = (self.start || Time.now) + 14.days
	end
	
	def display_time
		if self.start.nil?
			return ""
		end
		self.start.strftime("%Y-%m-%d") + " - " + self.stop.strftime("%Y-%m-%d")
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
