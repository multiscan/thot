class User < ActiveRecord::Base

  # For LDAP support:
  # http://corrupt.net/2010/07/05/LDAP-Authentication-With-Devise/
  # http://wiki.phys.ethz.ch/readme/devise_with_ldap_for_authentication_in_rails_3
  # https://github.com/cschiewek/devise_ldap_authenticatable
  # Invitable: https://github.com/scambra/devise_invitable
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :rememberable, :trackable, :validatable, :registerable,  :confirmable,
  # devise :database_authenticatable, :recoverable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :location, :nebis, :legacy_id
  # attr_accessible :name, :email, :password, :password_confirmation, :location, :nebis, :legacy_id
  attr_accessible :name, :email, :location, :nebis, :legacy_id, :lab_id, :notes

  # attr_accessible :title, :body
  validates_presence_of :name
  validates_presence_of :lab_id
  validates_presence_of :email
  validates_uniqueness_of :email, :case_sensitive => false

  belongs_to :lab                          # , :counter_cache => true
  has_many :loans, :conditions => { :return_date => nil }
  has_many :all_loans, :class_name => "Loan"
  def log
    "  name: #{self.name}\n  email: #{self.email}\n  nebis: #{self.nebis}\n  location: #{self.location}\n  legacy_id: #{self.legacy_id}\n  notes: #{self.notes}"
  end

  def lab_nick
    lab ? lab.nick : ""
  end

end


# comment.try(:user) == user || user.role?(:moderator)
