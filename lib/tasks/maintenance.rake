desc "Merge all books that look identical"
task :isbnmerge => [:environment, :cleanup_books] do
  mergecount=0
  Book.duplicated_isbn_count.each do |isbn, count|
    b=Book.find_all_by_isbn("#{isbn}", :order=>'id ASC')
    raise "count=#{count} and b.count=#{b.count} differs" if count != b.count
    nm = 0
    if count == 2
      if b[0].merge(b[1])
        nm=nm+1
      end
    else
      for i in 0...count
        next unless b[i].nil?
        for j in (i+1)...count do
          next unless b[j].nil?
          if b[i].merge(b[j])
            nm=nm+1
            b[j]=nil
          end
        end
      end
    end
    mergecount=mergecount+nm
    # puts "ISBN #{isbn} - #{count} books, #{nm} merged"
  end
  puts "----- #{mergecount} Succesfull merging in total."
end

desc "Update table of degenerate ISBN numbers"
task :update_degisbns => [:environment] do
  n=0
  t=0
  Book.duplicated_isbn_count.each do |isbn,count|
    i=DegIsbn.new(:isbn=>isbn, :count=>count)
    n=n+1 if i.save
    t=t+1
  end
  puts "Added #{n} new degenerate ISBNs out of #{t} found."
  puts "Now there are #{DegIsbn.count} degenerate ISBNs in total."
  puts "Out of which #{DegIsbn.where(skip: true).count} are marked as unmergeable"
end


desc "Destroy books with blank author, editor and isbn"
task :cleanup_books => [:environment] do
  puts "Destroying books with no author, editor, isbn..."
  n=m=0
  Book.where(:author => nil, :editor=>nil, :isbn=>nil, :title=>nil).each do |b|
    n=n+1
    m=m+b.items.count
    b.items.destroy_all
    b.destroy
  end
  puts "...#{n} books (#{m} items) destroied"
end
