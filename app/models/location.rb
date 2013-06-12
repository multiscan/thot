class Location < ActiveRecord::Base
  attr_accessible :name
  def self.names_list
    self.all.map{|l| l.name}
  end

  has_many :items, :class_name => "Item", :foreign_key => "location_id"
  has_many :shelves, :class_name => "Shelf", :foreign_key => "location_id"
end




