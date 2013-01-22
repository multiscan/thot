module Legacy
  class Base < ActiveRecord::Base
    self.abstract_class = true
    if Rails.env.production?
      establish_connection :legacy_prod
    else
      establish_connection :legacy_dev
    end
  end
end
