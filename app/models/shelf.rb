class Shelf < ActiveRecord::Base
  attr_accessible :location_id
  belongs_to :location, :class_name => "Location", :foreign_key => "location_id"
  has_many :items, :class_name => "Item", :foreign_key => "shelf_id"
  before_create :check_seqno
 private
  def check_seqno
    self.seqno ||= (self.location.shelves.count + 1)
  end
end