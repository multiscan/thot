class Location < ActiveRecord::Base
  attr_accessible :name
  validates_uniqueness_of :name, :on => :create, :message => "a room with this name already exists"

  def self.names_list
    self.pluck(:name).uniq
  end
  has_many :items, :class_name => "Item", :foreign_key => "location_id"
  has_many :shelves, :class_name => "Shelf", :foreign_key => "location_id"
end




