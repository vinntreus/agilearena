module ApplicationHelper

	include BreadcrumbHelper

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
	
	def link_button (text, path)
		link_to_unless_current(content_tag(:span, text), path, :class => "link-button") do
       link_to(content_tag(:span, text), path, :class => "link-button selected")
    end
	end	
	
	def breadcrumb
		return build_breadcrumb				
	end
	
end


