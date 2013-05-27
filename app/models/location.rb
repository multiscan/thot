class Location < ActiveRecord::Base
  attr_accessible :name
  def self.names_list
    self.all.map{|l| "'#{l.name}'"}.join(", ")
  end
end
