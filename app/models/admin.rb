class Admin < ActiveRecord::Base

  # https://github.com/ryanb/cancan/wiki/Role-Based-Authorization
  ROLES = %w[operator admin]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :role, :password, :password_confirmation, :remember_me, :lab_ids
  # attr_accessible :title, :body

  has_and_belongs_to_many :labs, :class_name => "Lab", :join_table => "operatorships"
  has_many :inventory_sessions, :class_name => "InventorySession", :foreign_key => "admin_id"

  def operates?(o)
    case o.class.name
    when "Lab"
      ! self.labs.find_by_id(o.id).nil?
    when "Fixnum"
      ! self.labs.find_by_id(o).nil?
    when "User"
      l=o.lab
      l.nil? ? false : (! self.labs.find_by_id(l.id).nil?)
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

  def used_locations
    self.labs.map{|l| l.locations}.flatten!.uniq
  end

end
