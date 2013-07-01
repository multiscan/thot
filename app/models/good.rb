class Good < ActiveRecord::Base

  # attr_accessible :inventory_session_id, :item_id, :previous_shelf_id, :current_shelf_id

  belongs_to :item, :class_name => "Item", :foreign_key => "item_id"
  belongs_to :inventory_session, :class_name => "InventorySession", :foreign_key => "inventory_session_id"
  belongs_to :current_shelf, :class_name => "Shelf", :foreign_key => "current_shelf_id"
  belongs_to :previous_shelf, :class_name => "Shelf", :foreign_key => "previious_shelf_id"

  def inv
    self.item_id
  end

  def inv=(i)
    self.item_id=i
  end

  def status(shelf_id)
    if    previous_shelf_id == shelf_id && current_shelf_id.nil?
      "missing"
    elsif previous_shelf_id == shelf_id && current_shelf_id != shelf_id
      "moved_out"
    elsif previous_shelf_id == shelf_id && current_shelf_id == shelf_id
      "confirmed"
    elsif  current_shelf_id == shelf_id && previous_shelf_id.nil?
      "imported"
    elsif  current_shelf_id == shelf_id && previous_shelf_id != shelf_id
      "moved_in"
    else
      "unrelated"
    end
  end

  def checked?
    !current_shelf_id.nil?
  end

end
