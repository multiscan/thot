# ------------------------------------------------------------------- Base Users
user = User.find_or_create_by_email(
              :name => ENV['ADMIN_NAME'].dup,
              :email => ENV['ADMIN_EMAIL'].dup,
              :password => ENV['ADMIN_PASSWORD'].dup,
              :password_confirmation => ENV['ADMIN_PASSWORD'].dup
            )
user.role='admin'
user.confirmed_at = DateTime.now
user.save

# if Rails.env == "development"
#   user = User.find_or_create_by_email(
#               :name => "Test User", :email => "ciccio.pasticcio@gmail.com",
#               :password => ENV['ADMIN_PASSWORD'].dup,
#               :password_confirmation => ENV['ADMIN_PASSWORD'].dup
#             )
#   user.confirmed_at = DateTime.now
#   user.save
# end


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
nlp=Legacy::Person.count
ilp=0
Legacy::Person.find(:all).each do |lp|
  ilp = ilp + 1
  # # skip users without nebis
  # nebis=lp.nebis
  # if nebis.nil?
  # #    "Skipping user #{lp.fullname} - #{lp.email}: invalide nebis"
  # #   next
  #   empty_nebis_count=empty_nebis_count+1
  #   nebis="empty_#{empty_nebis_count}"
  # end
  if lp.email.nil?
     "Skipping user #{lp.fullname} - #{lp.email}: empty email. Saved into 'special users'"
    special_users[lp.userId] = lp
    next
  end
  if p = User.find_by_email(lp.email)
    if p.nebis == "invalid" && lp.nebis != "invalid"
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
    :location   => lp.userLocation,
    :nebis      => lp.nebis,
    :legacy_id  => lp.userId,
    :password   => ENV['DEFAULT_USER_PASSWORD'].dup,
    :password_confirmation => ENV['DEFAULT_USER_PASSWORD'].dup
  )
  p.confirmed_at = DateTime.now
  lab=Lab.find_by_nick(lp.userLab)
  if lab
    p.lab=lab
  else
    p.lab = default_lab
    p.notes = "Original Lab: #{lp.userLab}"
  end
  # puts "User #{ilp}/#{nlp}\n#{p.log}"
  if p.save
    # puts "ok. #{p.id}"
  else
    puts "!!! Invalid user\n#{p.log}"
    exit
  end
end

# ----------------------------------------- Import books
pn=nil
p=nil
Legacy::Book.find(:all, :order => "publisher").each do |lb|
  if lb.publisher && lb.publisher != pn
    pn=lb.publisher
    p=Publisher.create(:name => pn)
    puts "New publisher: #{pn} -- #{p.name}"
  end

  # if another book with the same ISBN was found, merge attributes.
  # TODO: find a nicer way to merge attributes leaving to the user
  #       the choice of what to keep!
  #       we will do the merging later. for the moment we keep books with
  #       duplicate ISBN also because in some cases, different volumes of the
  #       same books have the same ISBN
  # if lb.isbn && !lb.isbn.empty? && b=Book.find_by_isbn(lb.isbn)
  #   puts "updating book #{b.id} with legacy book #{lb.invNumber}"
  #   puts "title: #{b.title || 'nil'} -- #{lb.title || 'nil'}"
  #   puts "author: #{b.author || 'nil'} -- #{lb.author || 'nil'}"
  #   puts "publisher: #{b.publisher ? b.publisher.name : 'nil'} -- #{lb.publisher || 'nil'}"
  #   puts "year: #{b.publication_year || 'nil'} -- #{lb.publicationYear || 'nil'}"
  #   b.editor            ||= lb.editor
  #   b.call1             ||= lb.call1
  #   b.call2             ||= lb.call2
  #   b.call3             ||= lb.call3
  #   b.call4             ||= lb.call4
  #   b.collation         ||= lb.collation
  #   b.edition           ||= lb.edition
  #   b.collection        ||= lb.collection
  #   b.language          ||= lb.language
  #   b.publication_year  ||= lb.publicationYear
  #   b.abstract          ||= lb.abstract
  #   b.toc               ||= lb.toc
  #   b.idx               ||= lb.idx
  #   b.notes             ||= lb.notes
  #   b.save!
  # else
  #   book_params = {
  #     :title            => lb.title        ,
  #     :author           => lb.author       ,
  #     :editor           => lb.editor       ,
  #     :call1            => lb.call1        ,
  #     :call2            => lb.call2        ,
  #     :call3            => lb.call3        ,
  #     :call4            => lb.call4        ,
  #     :collation        => lb.collation    ,
  #     :isbn             => lb.isbn         ,
  #     :edition          => lb.edition      ,
  #     :collection       => lb.collection   ,
  #     :language         => lb.language     ,
  #     :publication_year => lb.publicationYear ,
  #     :abstract         => lb.abstract     ,
  #     :toc              => lb.toc          ,
  #     :idx              => lb.idx          ,
  #     :notes            => lb.notes        ,
  #   }
  #   b = p ? p.books.create(book_params) : Book.create(book_params)
  # end

  book_params = {
    :title            => lb.title        ,
    :author           => lb.author       ,
    :editor           => lb.editor       ,
    :call1            => lb.call1        ,
    :call2            => lb.call2        ,
    :call3            => lb.call3        ,
    :call4            => lb.call4        ,
    :collation        => lb.collation    ,
    :isbn             => lb.isbn         ,
    :edition          => lb.edition      ,
    :collection       => lb.collection   ,
    :language         => lb.language     ,
    :publication_year => lb.publicationYear ,
    :abstract         => lb.abstract     ,
    :toc              => lb.toc          ,
    :idx              => lb.idx          ,
    :notes            => lb.notes        ,
  }
  b = p ? p.books.create(book_params) : Book.create(book_params)

  lab = Lab.find_by_nick(lb.lab)
  u = lb.userId ? ( User.find_by_legacy_id(lb.userId) || duplicate_users[lb.userId] ) : nil

  i = b.items.new(
    :status => lb.status,
    :inv    => lb.invNumber,
    :location => lb.location,  # this creates a new location if not found
    :price    => lb.price,
    :currency => lb.currency,
  )
  i.lab = lab

  i.borrower = u unless u.nil?
  if i.save
     "Created item #{i.inv}"
  end

end
