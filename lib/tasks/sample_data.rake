require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    
    User.all(:limit => 6).each do |user|
      50.times do
        user.backlogs.create!(:title => Faker::Lorem.sentence(5))
      end
    end
  end
end

