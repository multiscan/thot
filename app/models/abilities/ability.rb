# https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
# https://github.com/ryanb/cancan
# http://mikepackdev.com/blog_posts/12-managing-devise-s-current-user-current-admin-and-current-troll-with-cancan

class Abilities::Ability
  include CanCan::Ability
  def initialize()
    # Guest abilities (none)
  end
end
