class Search < ActiveRecord::Base
  attr_accessible :query, :isbn, :publisher_name, :year_range, :inv_range,
                  :lab_id, :location_id, :status, :inv_date_fr, :inv_date_to
  belongs_to :lab
  belongs_to :location

  validates_format_of :inv_range, with: /(^\s*[0-9]+\s*$)|(^\s*[0-9]+\s*((\.\.|-)\s*[0-9]+)?\s*$)|(^\s*[0-9]+(\s*,s*[0-9]+)*\s*$)/,
    message: "Format for range: N or N1..N2 or N1-N2 or N1,N2,N3 (where N is a number)", allow_nil: true, allow_blank: true

  def items
    @items ||= items_oriented? ? @entries : items_from_books
  end

  def books
    puts "books: @books=#{@books}    item_oriented? #{items_oriented?}"
    @books ||= items_oriented? ? books_from_items : @entries
  end

  # pagination shortcuts
  def per_page
    (@entries.nil? || @entries.empty?) ? 50 : @entries.per_page
  end

  def current_page
    (@entries.nil? || @entries.empty?) ? 0 : @entries.current_page
  end

  def next_page
    (@entries.nil? || @entries.empty?) ? 1 : @entries.next_page
  end

  def total_entries
    (@entries.nil? || @entries.empty?) ? 0 : @entries.total_entries
  end

  def total_pages
    (@entries.nil? || @entries.empty?) ? 0 : @entries.total_pages
  end

  def size
    (@entries.nil? || @entries.empty?) ? 0 : @entries.size
  end

  # def inventory_session
  #   nil
  # end

  # def inventory_session_id
  #   nil
  # end

  # def inventory_session=(is)
  #   puts "Should add search results to InventorySession #{is.name}"
  # end

  # def inventory_session_id=(is_id)
  #   is = InventorySession.find(is.id)
  #   inventory_session = is
  # end

  def search(params={})
    paginate_params = {:per_page => params[:per_page] || per_page, :page => params[:page] || next_page}
    @entries=nil
    @items=nil
    @book=nil

    # single inventory number
    if !inv_range.blank? && (i=parse_range(inv_range)).is_a?(Integer)
      inv=i # inv_range.strip.to_i
      logger.debug "Simple search for inv=#{inv}"
      @entries = Item.where(:inv=>inv)
      return
    end

    # bookle isbn
    unless isbn.blank?
      @entries = Book.where(:isbn => isbn)
      logger.debug "Simple search for isbn=#{isbn}"
      return
    end

    # # if query is present we use search (sphinx) otherwise we use standard SQL
    # if item_conds.empty? && book_conds.empty? && query.blank?
    # end

    if query.blank?
      if item_conds.empty? && book_conds.empty?
        @entries = []
        return
      end
      if book_conds.empty?
        logger.debug("SQL    search only on items: item_conds=#{item_conds.inspect}")
        if params[:items_only]
          @entries = Item.where(item_conds).paginate(paginate_params)
        else
          @entries = Item.includes(:inventoriable).where(item_conds).paginate(paginate_params)
        end
      else
        logger.debug("SQL    search: book_conds=#{book_conds.inspect}\n               item_conds=#{item_conds.inspect}")
        conditions=book_conds
        conditions[:items] = item_conds
        @entries = Book.includes(:items).where(conditions).paginate(paginate_params)
      end
    else
      # TODO: include remaining conditions on Book (year, publisher_id)
      conditions=book_conds.merge(item_conds)
      logger.debug("Sphinx search: query=#{query}\n               conds=#{conditions.inspect}")
      @entries = Book.search(query, {:with=>conditions}.merge(paginate_params))
    end
  end

  def publisher_ids
    @publisher_ids ||= publisher_ids_from_name(publisher_name)
  end

  def items_oriented?
    !inv_range.blank? || !inv_date_fr.blank? || !inv_date_to.blank? || !lab_id.blank? || !location_id.blank? || !status.blank?
  end

 private

  # conditions for books
  def book_conds
    unless @book_conds
      @book_conds={}
      unless publisher_ids.empty?
        @book_conds[:publisher_id] = publisher_id
      end
      unless year_range.blank?
        @book_conds[:pubyear] = parse_range(year_range)
      end
    end
    @book_conds
  end

  # conditions for items
  def item_conds
    unless @item_conds
      @item_conds = {}
      unless inv_range.blank?
        @item_conds[:inv] = parse_range(inv_range)
      end
      unless lab_id.blank?
        @item_conds[:lab_id] = lab_id
      end
      unless location_id.blank?
        @item_conds[:location_id] = location_id
      end
      unless status.blank?
        @item_conds[:status] = status.strip
      end
      unless inv_date_to.blank? && inv_date_fr.blank?
        fr = inv_date_fr.blank? ? Date.new(1970) : inv_date_fr  # .to_date not necessary because converted automatically
        to = inv_date_to.blank? ? Date.tomorrow : inv_date_to
        @item_conds[:created_at] =  fr..to
      end
    end
    @item_conds
  end

  def publisher_ids_from_name(n)
    return [] if n.blank?
    r=Publisher.where(:name => publisher_name)
    if r.empty?
      r=Publisher.where("name LIKE ?", n)
    end
    r.empty? ? [] : r.map{|p| p.id}
  end

  def books_from_items
    puts "books_from_items"
    return [] if @entries.nil? || @entries.empty?
    # @items.map{|i| i.book}.uniq
    ids = items.map{|i| i.inventoriable_id}
    Book.find(ids)
  end

  def items_from_books
    puts "items_from_books"
    return [] if @entries.nil? || @entries.empty?
    i=[]
    books.each {|b| i += b.items}
    return i
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
    elsif ys =~ /^\s*[0-9]+\s*/
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

  # def keyword_conditions
  #   ["products.name LIKE ?", "%#{keywords}%"] unless keywords.blank?
  # end

  # def minimum_price_conditions
  #   ["products.price >= ?", minimum_price] unless minimum_price.blank?
  # end

  # def maximum_price_conditions
  #   ["products.price <= ?", maximum_price] unless maximum_price.blank?
  # end

  # def category_conditions
  #   ["products.category_id = ?", category_id] unless category_id.blank?
  # end

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
