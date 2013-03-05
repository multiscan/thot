class Publisher < ActiveRecord::Base
  attr_accessible :name

  has_many :books

  def mergenda_ids
    nil
  end
end
