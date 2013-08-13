# TODO: why this ? is it still needed ?
require 'google_book'

class Book < ActiveRecord::Base
  extend Memoist

  # include ThinkingSphinx::Scopes
  # sphinx_scope(:date_order) { {:order => :created_at} }
  # default_sphinx_scope :date_order

  has_many :items, :as => :inventoriable
  # has_many :loans, :class_name => "Loan", :foreign_key => "book_id"
  # has_many :checkouts, :class_name => "Loan", :foreign_key => "book_id", :conditions=>{:return_date=>nil}
  has_many :loans, :through => :items
  has_many :checkouts, -> {where return_date: nil}, :class_name => "Loan", :through => :items, :source => :loans
  # has_many :available_items, :as => :inventoriable, :condition => ""
  belongs_to :publisher

  AttributesForEquality=["title", "author", "editor", "isbn", "edition", "volume", "publisher_id", "collection", "pubyear"]
  AttributesForMerging=["call1", "call2", "call3", "call4", "collation", "language", "abstract", "toc", "idx", "notes", "price", "currency"]

  validates_presence_of :isbn, :on => :save, :message => "can't be blank"
  validates_numericality_of :pubyear, :greater_than_or_equal_to => 1500,
                            :less_than_or_equal_to => Time.new.year+2, :only_integer => true, :allow_nil => true

  before_save :check_isbn13


  # define_index do
  #   indexes title, :sortable => true
  #   indexes author
  #   indexes editor
  #   indexes publisher.name, :as => :publisher, :sortable => true
  #   indexes author.name, :as => :author, :sortable => true
  #   # indexes call1
  #   # indexes call2
  #   # indexes call3
  #   # indexes call4

  #   # attributes
  #   has publisher_id, created_at, updated_at, isbn
  # end

  def sortable_call
    [self.call1, self.call2, self.call3, self.call4].map{|c| c.gsub(/([0-9.]+)/, ' \1 ').split(" ").map{|s| s =~ /^[0-9.]+$/ ? s.to_f : s} }
    [self.call1, (self.call2 =~ /^[0-9.]+$/ ? self.call2.to_f : self.call2) ] + "#{self.call3}#{self.call4}".gsub(/[^a-zA-Z.0-9]/,'').gsub(/([0-9.]+)/, ' \1 ').split(" ") # .map{|s| s =~ /^[0-9.]+$/ ? s.to_f : s}
  end

  def currency
    self.attributes[:currency] || ( self.price ? ENV["DEFAULT_CURRENCY"] : nil )
  end

  def status
    self.items
  end

  def count_on_loan
    set_counts unless @on_loan_count
    return @on_loan_count
  end
  def count_available
    set_counts unless @available_count
    return @available_count
  end
  def count_all
    set_counts unless @all_count
    return @all_count
  end
  def count_missing
    set_counts unless @missing_count
    return @missing_count
  end

  def publisher_name=(name)
    self.publisher = Publisher.find_or_create_by(name: name) unless name.blank?
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
    bb=self.ask_the_web(n).map{|bh| Book.new(bh)} if bb.empty?
    bb=[Book.new(:isbn=>n)] if bb.empty?
    return bb
  end

  def self.ask_the_web(n)
    lcb=LocBook.new(n)
    gbl = GoogleBookList.new(n)
    res = gbl.count > 0 ? gbl.to_ah : []
    res << lcb.to_h if lcb.found?
    res
  end

  def duplicate
    Book.create attributes.except("id", "created_at", "updated_at").merge(:parent_id => self.id)
  end

  def self.duplicated_isbn_count
    self.select("COUNT(isbn) as total, isbn").group(:isbn).having("COUNT(isbn) > 1 AND isbn!=''").order('total').map{|b| [b.isbn,b.total]}
  end

  def isbn_checksum(isbn_string)
    digits = isbn_string.split(//).map(&:to_i)
    transformed_digits = digits.each_with_index.map do |digit, digit_index|
      digit_index.modulo(2).zero? ? digit : digit*3
    end
    transformed_digits.reduce(:+)
  end

  def is_valid_isbn13?(isbn13)
    checksum = isbn_checksum(isbn13)
    checksum.modulo(10).zero?
  end

  def isbn13_checksum_digit(isbn12)
    checksum = isbn_checksum(isbn12)
    10 - checksum.modulo(10)
  end

 private

  def check_isbn13
    if self.isbn13.blank? && ! self.isbn.blank? && self.isbn.length == 13
      self.isbn13 = self.isbn
    end
  end

  def set_counts
    @all_count = items.count
    library_count = items.where(:status=>"Library").count
    @on_loan_count = checkouts.count
    @available_count = library_count - @on_loan_count
    @missing_count = @all_count - library_count
    logger.debug("set_counts: @all=#{@all_count}  on_loan=#{@on_loan_count}  available=#{@available_count}  missing=#{@missing_count}  library=#{library_count}")
  end

  memoize :duplicate_isbn?, :missing_isbn?, :with_same_isbn
end
