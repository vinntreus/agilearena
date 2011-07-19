class Sprint < ActiveRecord::Base
	attr_accessible :title
	before_create :set_title
	
	belongs_to :backlog
	
	def set_title
		if self.title.nil?
	    self.title = (self.backlog.sprints.count + 1).to_s
	  end
	end
end
