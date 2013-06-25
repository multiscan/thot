desc "Import legacy thot library database (should be done only at EPFL/IPG"
task :legacy_import => [:environment] do
# ------------------------------------------------------------------- Base Users
admin = Admin.find_or_create_by_email(
              :name => ENV['ADMIN_NAME'].dup,
              :email => ENV['ADMIN_EMAIL'].dup,
              :password => ENV['ADMIN_PASSWORD'].dup,
              :password_confirmation => ENV['ADMIN_PASSWORD'].dup
            )
admin.role='admin'
# admin.confirmed_at = DateTime.now
admin.save

# if Rails.env == "development"
#   user = User.find_or_create_by_email(
#               :name => "Test User", :email => "ciccio.pasticcio@gmail.com",
#               :password => ENV['ADMIN_PASSWORD'].dup,
#               :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#             )
#   user.confirmed_at = DateTime.now
#   user.save
# end

puts "Seed done. Remember to run the following maintenance rake tasks:"
puts "rake legacy_import"
puts "rake cleanup_books "
puts "rake isbnmerge"


# ------------------------------------------------------- Old database migration

# ------------------------------ Import labs
lab_nick_to_name = {
  'ABERER'      => 'Prof. Karl Aberer',
  'ALGO'        => 'Algorithmics Laboratory',
  'ARNI'        => 'Laboratory for Algorithmic Research on Networked Information',
  'BENAROUS'    => 'Benarous',
  'CMOS'        => 'CMOS',
  'LAMS'        => 'Systemic Modeling Laboratory',
  'LAPMAL'      => 'Laboratory for Probabilistic Machine Learning',
  'LCA'         => 'Laboratory for Communications and Applications',
  'LCAV'        => 'Audiovisual Communications Laboratory',
  'LCAV-LCM'    => 'Audiovisual Communications Laboratory and Mobile Communications Laboratory',
  'LCM'         => 'Mobile Communications Laboratory',
  'LEBLEBICI'   => 'Prof. Yusuf Leblebici',
  'LICOS'       => 'LICOS',
  'LSIR'        => 'Distributed Information Systems Laboratory',
  'LSM'         => 'Microelectronic Systems Laboratory',
  'LTHC'        => 'Communication Theories Laboratory',
  'LTHI'        => 'Information Theory Laboratory',
  'LTHI-LTHC'   => 'Information Processing Group',
  'RIMOLDI'     => 'Prof. Bixio Rimoldi',
  'SEEGER'      => 'Prof. Mathias Seeger',
  'SHOKROLLAHI' => 'Prof. Amin Shokrollahi',
  'TELATAR'     => 'Prof. Emre Telatar',
  'URBANKE'     => 'Prof. Ruediger Urbanke',
  'VETTERLI'    => 'Prof. Margin Vetterly',
  'UNKNOWN'     => 'Default lab for users with unknown affiliation',
}

lab_nick_to_name.each do |nick,name|
  Lab.create(:nick => nick, :name => name)
end

# Legacy::Lab.find(:all).each do |ll|1
#   k = ll.lab.downcase.to_sym
#   n = labs.delete(k)
#   if n
#     logger.info "Creating Lab for nick=#{ll.lab}: #{n}"
#     l = Lab.new ({
#       :nick => ll.lab,
#       :name => n
#     })
#     l.save
#   else
#     logger.info "Skipping creation of lab for nick=#{ll.lab}"
#   end
# end

# ----------------------------------------- Import library users
default_lab = Lab.find_by_nick("UNKNOWN")
duplicate_users={}
special_users={}
# empty_nebis_count=0
empty_email_count=0
Legacy::Person.find(:all).each do |lp|
  # # skip users without nebis
  # nebis=lp.nebis
  # if nebis.nil?
  # #    "Skipping user #{lp.fullname} - #{lp.email}: invalide nebis"
  # #   next
  #   empty_nebis_count=empty_nebis_count+1
  #   nebis="empty_#{empty_nebis_count}"
  # end
  unless lp.email?
    bc=lp.books.count
    if bc > 0
      puts "Generating invalid e-mail (#{lp.email}) for legacy user with empty e-mail and #{bc} books: #{lp.userFirst} #{lp.userLast} - #{lp.nebis}"
    else
      "Skipping legacy user with empty e-mail and zero books: #{lp.userFirst} #{lp.userLast} - #{lp.nebis}"
    end
    next
  end
  p=nil
  if p = User.find_by_email(lp.email)
    if ( p.nebis == "invalid" || p.nebis == "empty" ) && lp.nebis != "invalid" && lp.nebis != "empty"
       "Duplicate email: #{lp.userEmail} but usefull NEBIS"
      p.nebis=lp.nebis
      p.save
    else
       "Duplicate email: #{lp.userEmail}"
    end
    duplicate_users[lp.userId] = p
    next
  end
  p = User.new(
    :name       => lp.fullname,
    :email      => lp.email,
    # :location   => lp.userLocation,
    :nebis      => lp.nebis,
    :legacy_id  => lp.userId,
    # :password   => ENV['DEFAULT_USER_PASSWORD'].dup,
    # :password_confirmation => ENV['DEFAULT_USER_PASSWORD'].dup
  )
  # p.confirmed_at = DateTime.now
  lab=Lab.find_by_nick(lp.userLab)
  if lab
    p.lab=lab
  else
    p.lab = default_lab
    p.notes = "Original Lab: #{lp.userLab}"
  end
  if p.save
    # puts "ok. #{p.id}"
  else
    puts "!!! Invalid user\n#{p.log}\n#{p.errors.inspect}"
    exit
  end
end

# ----------------------------------------- Import books
pn=nil
p=nil
nb=0
Legacy::Book.find(:all, :order => "publisher").each do |lb|
  if lb.publisher && lb.publisher != pn
    pn=lb.publisher
    p=Publisher.create(:name => pn)
    puts "New publisher: #{pn} -- #{p.name}"
  end

  book_params = {
    :title            => lb.title,
    :subtitle         => nil,
    :categories       => nil,
    :author           => lb.author,
    :editor           => lb.editor,
    :call1            => lb.call1,
    :call2            => lb.call2,
    :call3            => lb.call3,
    :call4            => lb.call4,
    :collation        => lb.collation,
    :isbn             => lb.normalized_isbn,
    :edition          => lb.edition,
    :collection       => lb.collection,
    :language         => lb.language,
    :pubyear          => lb.normalized_year,
    :abstract         => lb.abstract,
    :toc              => lb.toc,
    :idx              => lb.idx,
    :notes            => lb.notes,
  }
  b = p ? p.books.new(book_params) : Book.new(book_params)
  unless b.save
    puts "Invalid book: #{b.inspect}"
    puts "        errs: #{b.errors}"
  end

  lab = Lab.find_by_nick(lb.lab)
  u = lb.userId ? ( User.find_by_legacy_id(lb.userId) || duplicate_users[lb.userId] ) : nil

  i = b.items.new(
    :status   => lb.status,
    :location_name => lb.location,  # this creates a new location if not found
    :price    => lb.price,
    :currency => lb.currency,
  )
  i.lab = lab
  # force id to be equal to inv so that we can get rid of inv
  i.id  = lb.invNumber

  i.save!
  i.checkout(u) unless u.nil?

  nb = nb+1
  if Item.count != nb || Book.count != nb
    puts "book: #{b.inspect}"
    puts "      valid? #{b.valid?}"
    puts "item: #{i.inspect}"
    puts "      valid? #{i.valid?}"
    puts "Legacy Book: #{lb.inspect}"
    raise "Inconsistent Book/Item count"
  end
end

# ISBN numbers with more than one book => creation of an entry in DegIsbn
# TODO: this should be done by the Book model....
Book.duplicated_isbn_count.each do |isbn,count|
  i=DegIsbn.create(:isbn=>isbn, :count=>count)
end

puts "Seed done. Remember to run the following maintenance rake tasks:"
puts "rake cleanup_books "
puts "rake isbnmerge"
end
