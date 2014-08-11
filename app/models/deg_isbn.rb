class DegIsbn < ActiveRecord::Base
  has_many :books, :class_name => "Book", :foreign_key => "isbn", :primary_key => "isbn"
  validates_uniqueness_of :isbn, :on => :create, :message => "must be unique"
  scope :editable, ->{ where(skip: false) }

  # def mergeables
  #   []
  # end

  # def mergeables=(a)
  #   puts "mergeables=   a=#{a.inspect}"
  # end
end
