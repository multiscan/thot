desc "Merge all books that look identical"
task :isbnmerge => [:environment] do
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
