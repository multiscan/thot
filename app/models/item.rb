class Item < ActiveRecord::Base
  attr_accessible :currency, :inventoriable, :inventoriable_type, :lab, :lab_id, :location_name, :location_id, :price, :status, :shelf_id

  belongs_to :inventoriable, :polymorphic => true
  belongs_to :lab                          # , :counter_cache => true
  belongs_to :location
  belongs_to :inventory, :class_name => "Inventory", :foreign_key => "inventory_id"
  belongs_to :shelf, :class_name => "Shelf", :foreign_key => "shelf_id"
  has_many :loans, :class_name => "Loan", :foreign_key => "item_id", :include => :user
  has_one :current_checkout, :class_name => "Loan", :foreign_key => "item_id", :conditions=>{:return_date=>nil}

  validates_presence_of :inventoriable_id, :on => :save, :message => "can't be blank"
  # validates_presence_of :inv
  # validates_uniqueness_of :inv, :message => "must be unique"

  after_create :autoset_inv

  # Thinking Sphinx Stuff
  define_index do
    indexes inventoriable(:title),  :as => :book_title
    indexes inventoriable(:author), :as => :book_author
    indexes inventoriable(:editor), :as => :book_editor

    where "inventoriable_type = 'Book'"

    # attributes
    has inv, lab_id, location_id, status
    has "books.publisher_id", :as=>:publisher_id, :type=>:integer
    has "books.pubyear", :as=>:pubyear, :type=>:integer
  end

  def location_name
    self.location.nil? ? "" : self.location.name
  end

  def location_name=(s)
    return if s.nil? || s.empty?
    l = Location.find_or_create_by_name(s)
    self.location = l
  end


  def price
    attributes[:price] || book.price
  end

  def currency
    attributes[:currency] || book.currency
  end

  def checkout(u, d=nil)
    return false if current_checkout && current_checkout.user_id != u.id
    b=self.loans.new(:user=>u)
    b.created_at = d if d
    b.save
  end

  def checkin
    current_checkout.checkin
  end

  def on_loan?
    ! current_checkout.nil?
  end

  def borrower_name
    on_loan? ? current_checkout.user.name : nil
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

  def self.statuses
    select("status").uniq.map{|s| s.status}.compact.delete_if{|s| s.nil? || s.blank?}
  end

 private

  def autoset_inv
    self.inv = id                    # Item.order('inv ASC').last.inv + 1 if inv.nil?
    self.save
  end
end
