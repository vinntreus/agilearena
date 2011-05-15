module ApplicationHelper

	def logo
		image_tag("logo.png", :alt => "AgileArena", :class => "logo")
	end

	def title
		base_title = "Agilearena"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end
end
