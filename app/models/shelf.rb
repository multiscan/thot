class Shelf < ActiveRecord::Base
  attr_accessible :location_id
  belongs_to :location, :class_name => "Location", :foreign_key => "location_id"
  has_many :items, :class_name => "Item", :foreign_key => "shelf_id"
end
