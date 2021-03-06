# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
#	user.id										 1
  user.name                  "Daniel Persson"
  user.email                 "gudski@gmail.com"
  user.password              "secret"
  user.password_confirmation "secret"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :backlog do |backlog|
  backlog.title "Foo bar"
  backlog.association :user
  backlog.backlog_item_next_display_id 1
end

Factory.define :sprint do |sprint|
  sprint.title "Fooo"
  sprint.start Time.now
	sprint.stop Time.now + 14.days
  sprint.association :backlog
end

Factory.define :backlog_item do |backlog_item|
  backlog_item.title "Foo bar"
  backlog_item.association :backlog
  backlog_item.description "test"
  backlog_item.position 1
end

Factory.define :collaborator do |col|
  col.association :user
  col.association :backlog
  col.role "member"
end
