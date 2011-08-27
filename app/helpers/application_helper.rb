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
	
	def link_button (text, path)
		link_to_unless_current(content_tag(:span, text), path, :class => "link-button") do
       link_to(content_tag(:span, text), path, :class => "link-button selected")
    end
	end
	
	def breadcrumb
		if params[:controller] == 'backlogs'
			link = link_to @backlog.user.name, @backlog.user
			backlog_link = link_to @backlog.title, @backlog
			return "<div id='breadcrumb-pre'></div><ol id='breadcrumb'><li>#{link}</li><li>#{backlog_link}</li></ol><div id='breadcrumb-post'></div>"		
		elsif params[:controller] == 'pages'
			page = 	params[:action].parameterize
			if page == 'home' && !current_user.nil?
				link = link_to current_user.name, current_user
				return "<div id='breadcrumb-pre'></div><ol id='breadcrumb'><li>#{link}</li></ol><div id='breadcrumb-post'></div>"
			end
		elsif params[:controller] == 'users' && !@user.nil? && !current_user.nil?
				link = link_to @user.name, @user
				return "<div id='breadcrumb-pre'></div><ol id='breadcrumb'><li>#{link}</li></ol><div id='breadcrumb-post'></div>"		
		end	
		
	end
end
