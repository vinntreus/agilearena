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

