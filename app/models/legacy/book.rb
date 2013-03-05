class Legacy::Book < Legacy::Base
  self.table_name="books"

  [:title, :author, :editor, :collation, :publisher, :edition, :collection, :abstract, :toc, :idx, :notes, :currency, :call1, :call2, :call3, :call4].each do |k|
    define_method(k.to_s) {
      v=read_attribute(k)
      begin
        vv=v.nil? ? nil : v.encode('utf-8', 'iso-8859-1')
        vv.blank? ? nil : vv
        return vv
      rescue
        return nil
      end
    }
  end

  def user_id
    ( self.userId.nil? || self.userId>500 ) ? nil : self.userId
  end

  def normalized_isbn
    return nil unless self.isbn?
    return nil if self.isbn =~ /[a-z][a-z][a-z]/
    self.isbn.upcase.gsub(/[^0-9X]/, "")
  end

  def normalized_year
    return nil unless self.publicationYear?
    return (1500 < self.publicationYear && self.publicationYear < 2014) ? self.publicationYear  : nil
  end
end
