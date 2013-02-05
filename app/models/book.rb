class Book < ActiveRecord::Base
  extend Memoist

  attr_accessible :abstract, :author, :call1, :call2, :call3, :call4, :collation, :collection, :currency, :edition, :editor, :idx, :isbn, :language, :notes, :price, :pubyear, :title, :toc, :publisher, :publisher_name, :volume

  has_many :items, :as => :inventoriable
  # has_many :available_items, :as => :inventoriable, :condition => ""
  belongs_to :publisher

  AttributesForEquality=["title", "author", "editor", "isbn", "edition", "volume", "publisher_id", "collection", "pubyear"]
  AttributesForMerging=["call1", "call2", "call3", "call4", "collation", "language", "abstract", "toc", "idx", "notes", "price", "currency"]

  validates_presence_of :isbn, :on => :save, :message => "can't be blank"
  validates_numericality_of :pubyear, :greater_than_or_equal_to => 1500,
                            :less_than_or_equal_to => Time.new.year+2, :only_integer => true, :allow_nil => true

  define_index do
    indexes title, :sortable => true
    indexes author
    indexes editor
    indexes publisher.name, :as => :publisher, :sortable => true
    indexes author.name, :as => :author, :sortable => true

    # attributes
    has publisher_id, created_at, updated_at, isbn
  end

  def currency
    self.attributes[:currency] || ( self.price ? ENV["DEFAULT_CURRENCY"] : nil )
  end

  def status
    self.items
  end

  def publisher_name=(name)
    self.publisher = Publisher.find_or_create_by_name(name) unless name.blank?
  end

  def publisher_name
    self.publisher ? self.publisher.name : nil
  end

  def publisher_name?
    !self.publisher.nil?
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

  def self.new_given_isbn(n)
    bb=Book.find_all_by_isbn(n)
    bb=self.ask_the_web(b) if bb.empty?
    bb=[Book.new(:isbn=>n)] if bb.empty?
    return bb
  end

  # TODO: actually fetch data from on-line databases (LOC, amazon etc.)
  def self.ask_the_web(n)
    [Book.new(:isbn=>n)]
  end

  def self.duplicated_isbn_count
    self.select("COUNT(isbn) as total, isbn").group(:isbn).having("COUNT(isbn) > 1 AND isbn!=''").order('total').map{|b| [b.isbn,b.total]}
  end

  memoize :duplicate_isbn?, :missing_isbn?, :with_same_isbn
end
