class Search < ActiveRecord::Base
  attr_accessible :query, :isbn, :publisher_id, :year_range, :borrower_id, :inv_range, :lab_id, :location_id, :status

  def items
    return @items unless @items.nil?
    search
    return @items unless @items.nil?
    @items = items_from_books
  end

  def books
    return @books unless @books.nil?
    search
    return @books unless @books.nil?
    @books = books_from_items
  end

  # reset search (invidate search results)
  def search!
    @items=nil
    @books=nil
  end

  private

  def books_from_items
    return [] if @items.nil? || @items.empty?
    @items.map{|i| i.book}.uniq
  end

  def items_from_books
    return [] if @books.nil? || @books.empty?
    i=[]
    @books.each {|b| i += @book.items}
  end

  def search
    return unless @items.nil? && @book.nil?

    # single inventory number
    if !inv_range.blank? && (i=parse_range(inv_range)).is_a?(Integer)
      inv=inv_range.strip.to_i
      @items = Item.includes(:inventoriable).where(:inv=>inv)
      return
    end

    # single isbn
    unless isbn.blank?
      @books = Book.where(:isbn => isbn)
      return
    end

    book_conds={}
    unless publisher_id.blank?
      book_conds[:publisher_id] = publisher_id
    end
    unless year_range.blank?
      book_conds[:pubyear] = parse_range(year_range)
    end

    item_conds={}
    unless borrower_id.blank?
      item_conds[:borrower_id] = borrower_id
    end
    unless inv_range.blank?
      item_conds[:inv] = parse_range(inv_range)
    end
    unless lab_id.blank?
      item_conds[:lab_id] = lab_id
    end
    unless location_id.blank?
      item_conds[:location_id] = location_id
    end
    unless status.blank?
      item_conds[:status] = status.strip
    end

    # if query is present we use search (sphinx) otherwise we use standard SQL
    if query.blank?
      conditions=book_conds
      conditions[:items] = item_conds
      @books = Book.includes(:items).where(conditions)
      return
    else
      # TODO: include remaining conditions on Book (year, publisher_id)
      @items = Item.search(query, :with=>item_conds)
    end
  end

  def parse_range(y)
    ys=y.strip
    if ys.index("..")
      f,t=ys.split("..").each{|v| v.strip.to_i}
      return f..t
    elsif ys.index("-")
      f,t=ys.split("-").each{|v| v.strip.to_i}
      return f..t
    elsif ys.index(",")
      return ys.split(",").map{|y| y.strip.to_i}
    elsif ys =~ /[0-9]+/
      return ys.to_i
    end
  end

  def find_books
    Product.find(:all, :conditions => book_conditions)
  end

  def find_items
    Product.find(:all, :conditions => item_conditions)
  end




  def title_book_conditions
    ["books.title LIKE ?", "%#{title}%"] unless title.blank?
  end

  def author_book_conditions
    ["books.title LIKE ?", "%#{title}%"] unless title.blank?
  end


  def keyword_conditions
    ["products.name LIKE ?", "%#{keywords}%"] unless keywords.blank?
  end

  def minimum_price_conditions
    ["products.price >= ?", minimum_price] unless minimum_price.blank?
  end

  def maximum_price_conditions
    ["products.price <= ?", maximum_price] unless maximum_price.blank?
  end

  def category_conditions
    ["products.category_id = ?", category_id] unless category_id.blank?
  end

  def book_conditions
    [book_conditions_clauses.join(' AND '), *conditions_options]
  end

  def book_conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def book_conditions_options
    book_conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def book_conditions_parts
    private_methods(false).grep(/_book_conditions$/).map { |m| send(m) }.compact
  end

  def item_conditions
    [item_conditions_clauses.join(' AND '), *conditions_options]
  end

  def item_conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def item_conditions_options
    book_conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def item_conditions_parts
    private_methods(false).grep(/_item_conditions$/).map { |m| send(m) }.compact
  end

end
