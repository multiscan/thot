class Shelf < ActiveRecord::Base
  belongs_to :location, :class_name => "Location", :foreign_key => "location_id"
  has_many :items, :class_name => "Item", :foreign_key => "shelf_id"
  before_create :check_seqno

  def items_count_for_inventory(i)
    i.in_shelf_count(self)
  end

 private

  def check_seqno
    self.seqno ||= (self.location.shelves.count + 1)
  end
end
