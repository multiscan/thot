class Loan < ActiveRecord::Base
  attr_accessible :item, :user

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :item, :class_name => "Item", :foreign_key => "item_id"
  belongs_to :book, :class_name => "Book", :foreign_key => "book_id"

  before_save :autoset_book

  validates_presence_of :user_id, :on => :create, :message => "can't be blank"
  validates_presence_of :item_id, :on => :create, :message => "can't be blank"
  validates_uniqueness_of :return_date, :scope => :item_id, :if => Proc.new {|l| l.return_date.nil? }, :message => "This item is alredy checked out"

  def self.checkout(u, i)
    user = u.is_a?(User) ? u : User.find(u)
    item = i.is_a?(Item) ? u : ( i.is_a?(String) ? Item.find_by_inv(i) : Item.find(i) )
    return nil if user.nil? or item.nil?
    existing = where(item_id: item.id, return_date: nil).first
    if existing
      if existing.user_id == user.id
        return existing
      else
        existing.checkin
      end
    end
    return Loan.new(:user => user, :item=> item)
  end

  def inv
    self.item ? self.item.inv : nil
  end

  def inv=(i)
    item = Item.find_by_inv(i)
    if item
      self.item = item
    end
  end

  def checkin
    self.return_date=Time.zone.now
    save
  end

  def overdue?
    return_date != nil && created_at < ENV["OVERDUE_AFTER"].to_i.months.ago
  end

  def self.find_all_overdue
    self.where(["return_date != ? AND created_at < ?", nil, ENV["OVERDUE_AFTER"].to_i.months.ago])
  end

  def age_in_days
     ( ( self.return_date || Time.zone.now ) - self.created_at ).to_i / 1.day
  end

 private

  def autoset_book
    write_attribute :book_id, item.inventoriable_id if item.inventoriable_type == "Book"
    return true
  end

end
