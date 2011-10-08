class Sprint < ActiveRecord::Base
	attr_accessible :title
	before_create :set_title
	
	belongs_to :backlog
	
	def set_title
		if self.title.nil?
	    self.title = (self.backlog.sprints.count + 1).to_s
	  end
	end
	
	def display_title
		if self.title.is_number?
			return "Sprint ##{self.title}"
		end
		return self.title
	end
end

#where to put this without include?
class String
  def is_number?
    true if Float(self) rescue false
  end
end
