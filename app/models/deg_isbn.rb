class DegIsbn < ActiveRecord::Base
  attr_accessible :isbn, :count, :mergeables
  has_many :books, :class_name => "Book", :foreign_key => "isbn", :primary_key => "isbn"

  def mergeables
    []
  end

  def mergeables=(a)
    puts "mergeables=   a=#{a.inspect}"
  end
end
