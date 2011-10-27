class Ability
  include CanCan::Ability
  
  

  def initialize(user)
		
		if !user.nil? #only for signed in users
			####################
			# Backlogitems
			####################
			can :create, BacklogItem do |item|
					item.backlog.user.id == user.id || item.backlog.is_member(user)
			end
			can :destroy, BacklogItem do |item|
					item.backlog.user.id == user.id 
			end
			can :update, BacklogItem do |item|
					item.backlog.user.id == user.id || item.backlog.is_member(user)
			end  	
			can :sort, BacklogItem do |item|
					item.backlog.user.id == user.id
			end
			can :create_items_in, Backlog do |item|
					item.user.id == user.id || item.is_member(user)
			end
			can :edit_items_in, Backlog do |item|
					item.user.id == user.id #|| item.is_member(user)
			end

			####################
			# Users
			####################  	
			can :create_backlogs, User do |item|
				 item.id == user.id
			end

			####################
			# Backlogs
			####################
			can :read, Backlog do |item|
				if item.private?
					item.user.id == user.id || item.is_member(user)
				else
					true
				end
			end
				can :destroy, Backlog do |item|
      	  item.user.id == user.id
      	end
		end  	
	
	

  	#can :update, BacklogItem, :backlog => { :user => user }
  	#can :destroy, BacklogItem, :backlog => { :user => user }
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
