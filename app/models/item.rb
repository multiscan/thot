class Item < ActiveRecord::Base
  attr_accessible :currency, :inv, :inventoriable, :inventoriable_type, :lab, :lab_id, :location, :location_id, :price, :status, :borrower

  belongs_to :inventoriable, :polymorphic => true
  belongs_to :lab
  # belongs_to :borrower, :class_name => User, :foreign_key => "borrower_id"
  belongs_to :location
  has_many :borrowings, :class_name => "Borrowing", :foreign_key => "item_id", :include => :user
  has_one :current_checkout, :class_name => "Borrowing", :foreign_key => "item_id", :conditions=>{:return_date=>nil}

  validates_presence_of :inventoriable_id, :on => :save, :message => "can't be blank"
  validates_uniqueness_of :inv, :message => "must be unique"

  define_index do
    indexes inventoriable(:title), :as => :book_title
    indexes inventoriable(:author), :as => :book_author
    indexes inventoriable(:editor), :as => :book_editor

    where "inventoriable_type = 'Book'"

    # attributes
    has inv, lab_id, location_id, status
    has "books.publisher_id", :as=>:publisher_id, :type=>:integer
    has "books.pubyear", :as=>:pubyear, :type=>:integer
  end

  def location=(name_or_location)
    return if name_or_location.nil? || name_or_location.empty?
    # puts "location=#{name_or_location}"
    l = name_or_location.class==String ? Location.find_or_create_by_name(name_or_location) : name_or_location
    # puts "l=#{l}"
    self.location_id = l.id
  end

  def price
    attributes[:price] || book.price
  end

  def currency
    attributes[:currency] || book.currency
  end

  def checkout(u)
    return false if current_checkout && current_checkout.user_id != u.id
    b=self.borrowings.new(:user=>u)
    b.save
  end

  def checkin
    current_checkout.checkin
  end

  def location_name
    self.location.nil? ? "" : self.location.name
  end

  def borrower_name
    self.borrower.nil? ? "" : self.borrower.name
  end

  def self.count_by_status
    self.select("COUNT(status) as total, status").group(:status).order('total').map{|i| [i.status,i.total]}
  end

  def self.count_by_lab
    # TODO this can be much more efficient using join with lab
    self.select("COUNT(lab_id) as total, lab_id").group(:lab_id).order('total').map{|i| [i.lab_id,i.total]}
  end

  def self.count_by_lab_and_status
    self.select("COUNT(lab_id) as total, lab_id, status").group("lab_id, status").order('lab_id, status').map{|i| {:lab_id => i.lab_id, :status => i.status, :count => i.total}}
  end

  def book
    self.inventoriable_type == "Book" ? self.inventoriable : nil
  end

end
