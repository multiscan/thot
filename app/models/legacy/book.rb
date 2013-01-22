class Legacy::Book < Legacy::Base
  self.table_name="books"

  [:title, :author, :editor, :collation, :publisher, :edition, :collection, :abstract, :toc, :idx, :notes, :currency].each do |k|
    define_method(k.to_s) {
      v=read_attribute(k)
      return v.nil? ? nil : v.encode('utf-8', 'iso-8859-1')
    }
  end

  def user_id
    ( self.userId.nil? || self.userId>500 ) ? nil : self.userId
  end

end
