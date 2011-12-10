class Collaborator < ActiveRecord::Base
  attr_accessible :role
  belongs_to :user
  belongs_to :backlog	
end
