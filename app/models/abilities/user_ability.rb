# https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
# https://github.com/ryanb/cancan
# http://mikepackdev.com/blog_posts/12-managing-devise-s-current-user-current-admin-and-current-troll-with-cancan

class Abilities::UserAbility < Abilities::NebisAbility
  include CanCan::Ability
  def initialize(user)
    # User abilities (none)
  end
end

