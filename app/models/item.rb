class Item < ActiveRecord::Base
  attr_accessible :currency, :inv, :inventoriable, :inventoriable_type, :lab, :price, :status, :borrower, :location

  belongs_to :inventoriable, :polymorphic => true
  belongs_to :lab
  belongs_to :borrower, :class_name => User, :foreign_key => "borrower_id"
  belongs_to :location

  def location=(name_or_location)
    return if name_or_location.nil? || name_or_location.empty?
    # puts "location=#{name_or_location}"
    l = name_or_location.class==String ? Location.find_or_create_by_name(name_or_location) : name_or_location
    # puts "l=#{l}"
    self.location_id = l.id
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

end
