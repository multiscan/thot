class User < ActiveRecord::Base

  # https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
  ROLES = %w[user operator admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,  :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :nebis, :legacy_id

  # attr_accessible :title, :body
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  belongs_to :lab

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def log
    "  name: #{self.name}\n  email: #{self.email}\n  nebis: #{self.nebis}\n  location: #{self.location}\n  legacy_id: #{self.legacy_id}\n  notes: #{self.notes}"
  end
end
