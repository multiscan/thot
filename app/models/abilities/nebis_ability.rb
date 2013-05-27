# https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
# https://github.com/ryanb/cancan
# http://mikepackdev.com/blog_posts/12-managing-devise-s-current-user-current-admin-and-current-troll-with-cancan

class Abilities::NebisAbility
  include CanCan::Ability
  def initialize(user)
    # User abilities for partially logged-in users (no password, ponly nebis code scanned)
    can [:read, :create], Loan
    can :update, Loan do |loan|
      loan.user_id == user.id
    end
  end
end

