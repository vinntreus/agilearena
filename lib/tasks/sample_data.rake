require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    
    User.all(:limit => 6).each do |user|
      50.times do				
				@backlog = user.backlogs.create!(:title => Faker::Lorem.sentence(5))
				
				10.times do				
					@backlog.backlog_items.create!(:title => Faker::Lorem.sentence(5))
				end
				
      end
    end
  end
end


namespace :db do
  desc "Add sortorder to backlogitems"
  task :sortorder => :environment do
    
    Backlog.all().each do |backlog|
    	@count = 1
    	backlog.backlog_items.all().each do |backlog_item|
    		backlog_item.position = @count
 				backlog_item.save
    		@count += 1
    	end
    end
  end
end

namespace :db do
  desc "set todo on empty statuses"
  task :clearstatus => :environment do

    Backlog.all().each do |backlog|
    	backlog.backlog_items.all().each do |backlog_item|
    		backlog_item.status ||= "Todo"
 				backlog_item.save
    	end
    end
  end
end

namespace :db do
  desc "Add display_id to backlogitems"
  task :display_id => :environment do
    
    Backlog.all().each do |backlog|
    	@count = 1
    	backlog.backlog_items.all().each do |backlog_item|
    		backlog_item.display_id = @count
 				backlog_item.save
    		@count += 1
    	end
    	backlog.backlog_item_next_display_id = @count    
    	backlog.save	
    end
  end
end

namespace :db do
  desc "Update category_list from backlog item title"
  task :update_categories_from_title => :environment do    

		BacklogItem.all().each do |backlog_item|
   		backlog_item.capture_tags
   		puts backlog_item.title + "\n"
			BacklogItem.update(backlog_item.id, :title => backlog_item.title)
    end
    
  end
end
