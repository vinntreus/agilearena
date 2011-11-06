module BreadcrumbHelper
	
	def build_breadcrumb
		init_build
	
		append_links
		
		if @links.length == 0
			return ""
		end	
		
		add_links_to_content
		
		end_build		
				
		return @content
	end
	
	private 
	
	def append_links
		if @controller == 'backlogs' && @action != 'new'
			@links << link_to(@backlog.user.name, @backlog.user)
			@links << link_to(@backlog.title, @backlog)
			
		elsif @controller == 'pages'
			if @action == 'home' && !current_user.nil?
				@links << link_to(current_user.name, current_user)
			end				
			
		elsif @controller == 'users' && !@user.nil? && !current_user.nil?
				@links << link_to(@user.name, @user)
				
		elsif @controller == 'sprints' && @action == 'show'
			@links << link_to(@sprint.backlog.user.name, @sprint.backlog.user)
			@links << link_to(@sprint.backlog.title, @sprint.backlog)
			@links << link_to(@sprint.display_title, @sprint)
			
		elsif @controller == 'backlog_items' && (@action == 'show' || @action == 'edit')
			@links << link_to(@backlog_item.backlog.user.name, @backlog_item.backlog.user)
			@links << link_to(@backlog_item.backlog.title, @backlog_item.backlog)
			unless @backlog_item.sprint.nil?
				@links << link_to(@backlog_item.sprint.display_title, @backlog_item.sprint)
			end				
		end
	end
	
	def init_build
		init_content
		add_pre_div
		add_ol_start		
	end
	
	def end_build
		add_ol_end
		add_end_div
	end
	
	def add_links_to_content()
		@links.each do |l|
			@content += "<li>#{l}</li>"
		end		
	end
	
	def init_content
		@links = []
		@controller = params[:controller]
		@action = params[:action]
		@content = ""
	end
	
	def add_pre_div
		@content += "<div id='breadcrumb-pre'></div>"
	end
	
	def add_ol_start
		@content += "<ol id='breadcrumb'>"
	end

	def add_ol_end
		@content += "</ol>"
	end
	
	def add_end_div
		@content += "<div id='breadcrumb-post'></div>"
	end
	
end

