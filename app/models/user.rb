class User < ActiveRecord::Base

  # https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
  ROLES = %w[user operator admin]

  # For LDAP support:
  # http://corrupt.net/2010/07/05/LDAP-Authentication-With-Devise/
  # http://wiki.phys.ethz.ch/readme/devise_with_ldap_for_authentication_in_rails_3
  # https://github.com/cschiewek/devise_ldap_authenticatable
  # Invitable: https://github.com/scambra/devise_invitable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :rememberable, :trackable, :validatable, :registerable,  :confirmable,
  devise :database_authenticatable, :recoverable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :nebis, :legacy_id
  attr_accessible :name, :email, :password, :password_confirmation, :location, :nebis, :legacy_id

  # attr_accessible :title, :body
  validates_presence_of :name
  validates_uniqueness_of :email, :case_sensitive => false

  belongs_to :lab
  has_and_belongs_to_many :operated_labs, :class_name => "Lab", :join_table => "operatorships"
  has_many :loans, :include => [:item, :book]

  def operates?(o)
    case o.class.name
    when "Lab"
      ! self.operated_labs.find_by_id(o.id).nil?
    when "Fixnum"
      ! self.operated_labs.find_by_id(o).nil?
    when "User"
      l=o.lab
      l.nil? ? false : (! self.operated_labs.find_by_id(l.id).nil?)
    else
      false
    end
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def admin?
    self.role == "admin"
  end

  def log
    "  name: #{self.name}\n  email: #{self.email}\n  nebis: #{self.nebis}\n  location: #{self.location}\n  legacy_id: #{self.legacy_id}\n  notes: #{self.notes}"
  end

  def lab_nick
    lab ? lab.nick : ""
  end

end
