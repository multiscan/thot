class Legacy::Person < Legacy::Base
  self.table_name="people"

  has_many :books, :class_name => "Legacy::Book", :foreign_key => "userId", :primary_key => 'userId'

  def fullname
    "#{userFirst} #{userLast}".encode('utf-8', 'iso-8859-1')
  end

  def email
    e=self.userEmail
    e="user.#{self.userId}@invalid.ch" if e.nil? || e.empty? || e.index("@").nil?
    return e.downcase
  end

  def email?
    e=self.userEmail
    !(e.nil? || e.empty? || e.index("@").nil?)
  end

  def nebis
    n=self.userNEBIS
    return n.nil? || n.empty?  ? "empty" : ( n.start_with?("E") ? n : "invalid" )
  end
end
