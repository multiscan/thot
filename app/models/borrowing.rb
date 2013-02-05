class Borrowing < ActiveRecord::Base
  attr_accessible :item, :user

  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :item, :class_name => "Item", :foreign_key => "item_id"
  belongs_to :book, :class_name => "Book", :foreign_key => "book_id"

  before_save :autoset_book

  def checkin
    return_date=Time.now
    save
  end

  def self.find_all_overdue
    self.where(["return_date != ? AND created_at < ?", nil, ENV["OVERDUE_AFTER"].to_i.months.ago])
  end

 private

  def autoset_book
    write_attribute :book_id, item.inventoriable_id if item.inventoriable_type == "Book"
    return true
  end

end
