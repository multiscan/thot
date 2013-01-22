class Book < ActiveRecord::Base
  extend Memoist

  attr_accessible :abstract, :author, :call1, :call2, :call3, :call4, :collation, :collection, :currency, :edition, :editor, :idx, :isbn, :language, :notes, :price, :publication_year, :title, :toc, :publisher

  has_many :items, :as => :inventoriable
  belongs_to :publisher

  AttributesForEquality=["title", "author", "editor", "isbn", "edition", "volume", "publisher_id", "collection", "publication_year"]
  AttributesForMerging=["call1", "call2", "call3", "call4", "collation", "language", "abstract", "toc", "idx", "notes", "price", "currency"]

  def publisher=(name_or_publisher)
    return if name_or_publisher.nil? || name_or_publisher.empty?
    p = name_or_publisher.class==String ? Publisher.find_or_create_by_name(name_or_publisher) : name_or_publisher
    self.publisher_id = p.id
  end

  def with_same_isbn
    return [] if missing_isbn?
    Book.where(:isbn => self.isbn)
  end

  def missing_isbn?
    self.isbn.nil? || self.isbn.empty?
  end

  def duplicate_isbn?
    return false if missing_isbn?
    return with_same_isbn.count > 1
  end

  def same_book?(b)
    a=self.attributes
    b=b.attributes
    AttributesForEquality.each do |k|
      return false if a[k] != b[k]
    end
    return true
  end

  # merge b into self if they are identical
  # return true if done, false if not possible because books differ
  def merge(b)
    return false unless self.same_book?(b)
    self.merge!(b)
  end

  # merge b into self even if they look different
  def merge!(b)
    b.items.each do |i|
      self.items << i
      self.save!
    end
    AttributesForMerging.each do |k|
      if (self[k].nil? || self[k].empty?) && !(b[k].nil? || b[k].empty?)
        self[k]=b[k]
      end
    end
    self.save!
    b.destroy
    true
  end

  def self.duplicated_isbn_count
    self.select("COUNT(isbn) as total, isbn").group(:isbn).having("COUNT(isbn) > 1 AND isbn!=''").order('total').map{|b| [b.isbn,b.total]}
  end

  memoize :duplicate_isbn?, :missing_isbn?, :with_same_isbn
end
