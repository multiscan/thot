class Publisher < ActiveRecord::Base

  has_many :books

  def mergenda_ids
    nil
  end
end
