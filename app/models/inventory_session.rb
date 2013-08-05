class InventorySession < ActiveRecord::Base
  # attr_accessible :name, :notes, :references, :admin_id
  belongs_to :admin, :class_name => "Admin", :foreign_key => "admin_id"
  has_many :goods, :class_name => "Good", :foreign_key => "inventory_session_id", :dependent => :destroy
  # has_many :unchecked_goods, :class_name => "Good", :foreign_key => "inventory_session_id", :conditions=>{:current_shelf_id=>nil}
  has_many :checked_goods, -> {where "current_shelf_id IS NOT NULL"}, :class_name => "Good", :foreign_key => "inventory_session_id"
  has_and_belongs_to_many :items, -> {uniq}, :join_table => "goods", :foreign_key => "inventory_session_id"
  has_and_belongs_to_many :book_items, -> {where(inventoriable_type: "Book").uniq}, :join_table => "goods", :foreign_key => "inventory_session_id", :class_name => "Item"

  # ----------------------------------------------------------------------------

  # def books_by_call
  #   self.items.joins("JOIN books ON books.id = items.inventoriable_id AND items.inventoriable_type = 'Book'").order("books.call1 ASC, books.call2 ASC, books.call3 ASC, books.call4 ASC")
  # end

  def books_by_call_for_listing
    items.joins(
        "JOIN books ON books.id = items.inventoriable_id AND items.inventoriable_type = 'Book'"
      ).joins(
        "JOIN labs ON labs.id = items.lab_id"
      ).order(
        "books.call1 ASC, books.call2 ASC, books.call3 ASC, books.call4 ASC, items.id ASC"
      ).select(
        "items.id, labs.nick as lab_nick, books.title, books.call1, books.call2, books.call3"
      )
  end

  def in_shelf_count(s)
    goods.where(current_shelf_id: s.id).count
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

  def imported_goods
    self.checked_goods.where(:previous_shelf_id => nil)
  end
  def imported_count
    @imported_count ||= checked_count == 0 ? 0 : (@moved_count.nil? || @confirmed_count.nil?) ? imported_goods.count : @checked_count - @moved_count - @confirmed_count
  end

  def moved_goods
    self.checked_goods.where("previous_shelf_id != current_shelf_id AND previous_shelf_id IS NOT NULL")
  end
  def moved_count
    @moved_count ||= checked_count == 0 ? 0 : (@confirmed_count.nil? || @imported_count.nil?) ? moved_goods.count : @checked_count - @confirmed_count - @imported_count
  end

  def imported_or_moved_goods
    # comparison with NULL is not permitted in sql
    self.checked_goods.where("current_shelf_id IS NOT NULL").where("previous_shelf_id IS NULL OR previous_shelf_id != current_shelf_id")
  end
  # def imported_or_moved_count
  #   @import_or_moved_count ||= imported_count + moved_count
  # end

  def confirmed_goods
    self.checked_goods.where("previous_shelf_id = current_shelf_id")
  end
  def confirmed_count
    @confirmed_count ||= checked_count == 0 ? 0 : (@moved_count.nil? || @imported_count.nil?) ? confirmed_goods.count : @checked_count - @moved_count - @imported_count
  end

  def missing_goods
    self.goods.where(:current_shelf_id => nil)
  end

  def progress
    @progress ||= total_count > 0 ? (100.0 * checked_count / total_count + 0.5).to_i : "--"
  end

  def move_committable
    imported_or_moved_goods.where(commit: [0,2])
  end
  def move_committable_count
    @move_committable_count ||= move_committable.count
  end
  def move_committed
    imported_or_moved_goods.where(commit: [1, 3])
  end
  def move_committed_count
    @move_committed_count ||= move_committed.count
  end

  def missing_committable
    missing_goods.where(commit: [0,1])
  end
  def missing_committable_count
    @missing_committable_count ||= missing_committable.count
  end
  def missing_committed
    missing_goods.where(commit: [2,3])
  end
  def missing_committed_count
    @missing_committed_count ||= missing_committed.count
  end

  def shelves
    unless @shelves
      c=self.goods.where('current_shelf_id IS NOT NULL').select(:current_shelf_id).uniq.map{|g| g.current_shelf_id}
      p=self.goods.where('previous_shelf_id IS NOT NULL').select(:previous_shelf_id).uniq.map{|g| g.previous_shelf_id}
      ids=(c + p).uniq
      @shelves = Shelf.find(ids)
    end
    @shelves
  end

  # ----------------------------------------------------------------------------

  def commit_moves
    count=0
    move_committable.each do |g|
      g.item.checkin
      g.item.update_attributes(shelf_id: g.current_shelf_id, status: "Library")
      g.update_attribute(:commit, g.commit+1)
      count = count + 1
    end
    count
  end

  def commit_missings
    count=0
    missing_committable.each do |g|
      i = g.item
      s = case i.status
        when "Library"
          "Missing once"
        when "Missing once"
          "Missing twice"
        when "Missing twice"
          "Missing three times"
        when "Missing three times"
          "Lost"
        else
          "Missing"
        end
      i.update_attribute("status", s)
      g.update_attribute(:commit, g.commit+2)
      count = count + 1
    end
    count
  end

  # add an item to this inventory session
  def inventorize(item)
    # g = Good.first_or_create({:inventory_session_id => id, :item_id=>item.id})
    g = self.goods.where(:item_id=> item.id).first_or_create()
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
