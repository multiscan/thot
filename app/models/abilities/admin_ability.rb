# https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
# https://github.com/ryanb/cancan
# http://mikepackdev.com/blog_posts/12-managing-devise-s-current-user-current-admin-and-current-troll-with-cancan

class Abilities::AdminAbility
  include CanCan::Ability

  def initialize(admin)
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

    # admin ||= Admin.new # guest user (not logged in)
    return if admin.nil?
    if admin.role? :admin
      can :manage, :all
      return
    end
    if admin.role? :operator
        lab_ids=admin.labs.map{|l| l.id}
        # TODO: operator can only operate on items/users belonging to labs he is operator for
        can :create, User
        can [:read, :update], User, :lab_id => lab_ids
        can :destroy, User do |u|
            u.loans.count == 0 && lab_ids.include?(u.lab_id)
        end
        can :create, Item
        can [:read, :update, :destroy], Item, :lab_id => lab_ids
        # can [:read, :update, :destroy], Item do |item|
        #    admin.labs.include?(item.lab)
        # end
        can [:read, :create, :update], [Book, Publisher, DegIsbn, Location]
        can :destroy, Book do |book|
          book.items.empty?
        end
        can :destroy, Location do |location|
          location.items.empty?
        end
        can [:read, :create], Shelf
        can :destroy, Shelf do |shelf|
            shelf.items.empty?
        end
        can :manage, Good do |good|
            good.inventory_session.admin_id == admin.id
        end
    end

  end
end
