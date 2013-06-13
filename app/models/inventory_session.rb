class InventorySession < ActiveRecord::Base
  attr_accessible :name, :notes, :references
  belongs_to :admin, :class_name => "Admin", :foreign_key => "admin_id"
  has_many :goods, :class_name => "Good", :foreign_key => "inventory_session_id"
  has_many :unchecked_goods, :class_name => "Good", :foreign_key => "inventory_session_id", :conditions=>{:shelf_id=>nil}
  has_and_belongs_to_many :items, :join_table => "goods", :foreign_key => "inventory_session_id", :uniq => true

  def inventorize(item)
    # g = Good.first_or_create({:inventory_session_id => id, :item_id=>item.id})
    g = goods.where(:item_id=> item.id).first_or_create
    g.update_attribute(:shelf_id, nil)
  end

  def inventorize_search(s)
    p=1
    while (p)
      s.search(only_items: true, per_page: 100, page: p)
      s.items.each { |i| inventorize(i) }
      p=s.next_page
    end
  end
end
