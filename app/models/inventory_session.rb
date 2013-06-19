class InventorySession < ActiveRecord::Base
  attr_accessible :name, :notes, :references, :admin_id
  belongs_to :admin, :class_name => "Admin", :foreign_key => "admin_id"
  has_many :goods, :class_name => "Good", :foreign_key => "inventory_session_id"
  # has_many :unchecked_goods, :class_name => "Good", :foreign_key => "inventory_session_id", :conditions=>{:current_shelf_id=>nil}
  has_many :checked_goods, :class_name => "Good", :foreign_key => "inventory_session_id", :conditions=>"current_shelf_id IS NOT NULL"
  has_and_belongs_to_many :items, :join_table => "goods", :foreign_key => "inventory_session_id", :uniq => true

  def imported_goods
    self.checked_goods.where(:previous_shelf_id => nil)
  end

  def moved_goods
    self.checked_goods.where("previous_shelf_id != current_shelf_id")
  end

  def confirmed_goods
    self.checked_goods.where("previous_shelf_id = current_shelf_id")
  end

  def total_count
    @total_count ||= goods.count
  end

  def checked_count
    @checked_count ||= checked_goods.count
  end

  def unchecked_count
    total_count - checked_count
  end

  def moved_count
    @moved_count ||= checked_count == 0 ? 0 : (@confirmed_count.nil? || @imported_count.nil?) ? moved_goods.count : @checked_count - @confirmed_count - @imported_count
  end

  def imported_count
    @imported_count ||= checked_count == 0 ? 0 : (@moved_count.nil? || @confirmed_count.nil?) ? imported_goods.count : @checked_count - @moved_count - @confirmed_count
  end

  def confirmed_count
    @confirmed_count ||= checked_count == 0 ? 0 : (@moved_count.nil? || @imported_count.nil?) ? confirmed_goods.count : @checked_count - @moved_count - @imported_count
  end

  def progress
    @progress ||= total_count > 0 ? (100.0 * checked_count / total_count + 0.5).to_i : "--"
  end

  # add an item to this inventory session
  def inventorize(item)
    # g = Good.first_or_create({:inventory_session_id => id, :item_id=>item.id})
    g = goods.where(:item_id=> item.id).first_or_create()
    g.update_attributes(current_shelf_id: nil, previous_shelf_id: item.shelf_id)
  end

  # add all items returned by the given search to this inventory session
  def inventorize_search(s)
    p=1
    while (p)
      s.search(only_items: true, per_page: 100, page: p)
      s.items.each { |i| inventorize(i) }
      p=s.next_page
    end
  end
end
