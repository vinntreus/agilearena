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
	
	def breadcrumb
		if params[:controller] == 'backlogs'
			link = link_to @backlog.user.name, @backlog.user
			backlog_link = link_to @backlog.title, @backlog
			return "<ol id='breadcrumb'><li>#{link}</li><li>#{backlog_link}</li></ol>"			
		end	
	end
end
