class DegIsbn < ActiveRecord::Base
  attr_accessible :isbn, :count
  def books
    @books ||= Book.find_all_by_isbn(self.isbn)
    update_attribute(:count, @books.count)
    @books
  end
end
