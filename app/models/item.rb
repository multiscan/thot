class Item < ActiveRecord::Base
  # attr_accessible :currency, :inventoriable, :inventoriable_type, :lab, :lab_id, :location_name, :location_id, :price, :status, :shelf_id

  scope :book, -> { where(inventoriable_type: 'Book') }
  belongs_to :inventoriable, :polymorphic => true, :foreign_key => "inventoriable_id"
  belongs_to :lab                          # , :counter_cache => true
  belongs_to :location
  belongs_to :shelf, :class_name => "Shelf", :foreign_key => "shelf_id"
  has_many :loans, -> {includes :user}, :class_name => "Loan", :foreign_key => "item_id"
  has_one :current_checkout, -> {where return_date: nil}, :class_name => "Loan", :foreign_key => "item_id"


  has_many :goods, :class_name => "good", :foreign_key => "item_id"

  validates_presence_of :inventoriable_id, :on => :save, :message => "can't be blank"
  # validates_presence_of :inv
  # validates_uniqueness_of :inv, :message => "must be unique"

  after_create :autoset_inv

  ORDERING_CRITERIA=[
    {desc: "inventory number, ascending", order: "items.id ASC"},
    {desc: "inventory number, descending", order: "items.id DESC"},
    {desc: "lab", order: "labs.nick ASC", includes: [:lab]},
    {desc: "location", order: "location_id ASC, shelf_id ASC"},
    {desc: "call", order: "items.call1 ASC, items.call2 ASC, items.call3 ASC, items.call4 ASC"},
  ]

  STATUSES=["Library", "Missing", "Lost", "Mystery", "Missing once", "Missing twice", "Missing three times", "Never Received", "Out of Print", "Waiting for Delivery"]

  # # Thinking Sphinx Stuff
  # define_index do
  #   indexes inventoriable(:title),  :as => :book_title
  #   indexes inventoriable(:author), :as => :book_author
  #   indexes inventoriable(:editor), :as => :book_editor

  #   where "inventoriable_type = 'Book'"

  #   # attributes
  #   has lab_id, location_id, status #, call1, call2, call3, call4
  #   has "books.publisher_id", :as=>:publisher_id, :type=>:integer
  #   has "books.pubyear", :as=>:pubyear, :type=>:integer
  # end

  # def book_id
  #   inventoriable_type == "Book" ? inventoriable_id : nil
  # end

  def location_name
    self.location.nil? ? "" : self.location.name
  end

  def location_name=(s)
    return if s.nil? || s.empty?
    l = Location.find_or_create_by_name(s)
    self.location = l
  end

  def shelf_seqno
    self.shelf.nil? ? nil : self.shelf.seqno
  end

  def shelf_seqno=(s)
    unless self.location_id.nil?
      s=Shelf.where(seqno: s, location_id: self.location_id).first
      unless s.nil?
        self.shelf_id = s.id
      end
    end
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
    if current_checkout.nil?
      false
    else
      current_checkout.checkin
      true
    end
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
