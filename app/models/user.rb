class User < ActiveRecord::Base

  # https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
  ROLES = %w[user admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,  :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
