require 'open-uri'

class GoogleBook
  def initialize(id)
    url="https://www.googleapis.com/books/v1/volumes/#{id}"
    begin
      @data=ActiveSupport::JSON.decode(open(url).read)
    rescue
      @data=nil
    end
  end
  def found?
    !@data.nil?
  end
  def id
    @data["id"]
  end
  def infolink
    return nil unless found?
    @data["infoLink"] || "http://books.google.com/books?id=#{id}&hl=&source=gbs_api"
  end
  def title
    volinfo["title"]
  end
  def subtitle
    volinfo["subtitle"]
  end
  def author
    volinfo["authors"].join(", ")
  end
  def publisher
    volinfo["publisher"]
  end
  def pubyear
    return nil unless found?
    @pubyear ||= parse_date(volinfo["publishedDate"])
  end
  def description
    volinfo["description"]
  end
  def collation
    return nil unless found?
    unless @collation
      p=[]
      p << "#{pages} pages" if pages
      p << size unless size.empty?
      @collation = p.join("; ")
    end
    @collation
  end
  def isbn_10
    identifiers["ISBN_10"]
  end
  def isbn_13
    identifiers["ISBN_13"]
  end
  def isbn
    isbn_10 || isbn_13
  end
  def pages
    volinfo["pageCount"]
  end
  def categories
    volinfo["categories"]
  end
  def tags
    unless @tags
      c=volinfo["categories"]
      if c
        t=[]
        c.each {|cc| t += cc.split("/")}
        t.delete("General")
        @tags = t.sort.uniq
      else
        @tags=[]
      end
    end
    @tags
  end
  def language
    volinfo["language"]
  end

  def imagelink
    return nil unless found?
    images["large"] || images["medium"] || images["small"] || images["thumbnail"] || images["smallThumbnail"]
  end

  def to_h
    return {} unless found?
    b={
        :title => title,
        :isbn => isbn,
        :pubyear => pubyear,
        :author => author,
        :publisher_name => publisher,
        :abstract => description,
        :collation => collation
      }
      return b
  end

 private

  def volinfo(i=0)
    return nil unless found?
    @volinfo ||= @data["volumeInfo"] || {}
  end

  def authors
    return [] unless found?
    volinfo["authors"] || []
  end

  def identifiers
    return nil unless found?
    unless @identifiers
      @identifiers = {}
      (volinfo["industryIdentifiers"] || []).each do |i|
        @identifiers[i["type"]] = i["identifier"]
      end
    end
    @identifiers
  end

  def images
    volinfo["imageLinks"] || {}
  end

  def size
    return nil unless found?
    unless @size
      dims=volinfo["dimensions"]
      if dims
        h,w,t=dims["height"], dims["width"], dims["thickness"]
        p=[]
        p << "h: #{h}" if h
        p << "w: #{w}" if w
        p << "t: #{t}" if t
        @size = p.join(", ")
      else
        @size = ""
      end
    end
    @size
  end

  # TODO:
  def parse_date(s)
    s ? s.gsub(/^.*([0-9][0-9][0-9][0-9]).*$/, '\1').to_i : nil
  end
end

class GoogleBookList
  def initialize(isbn)
    url="https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
    begin
      @list=ActiveSupport::JSON.decode(open(url).read)
      @count=@list["totalItems"]
    rescue
      @list=nil
      @count=0
    end
    if @count > 0
      # WARNING: I keep only the first page...
      @count = @list["items"].size
      @items=Array.new(@count, nil)
    else
      @count = 0
      @items = []
    end
  end

  def all
    @items.each_index {|i| at(i)}
    @items
  end

  def to_ah
    all.map {|i| i.to_h}
  end

  def count
    @count
  end

  def [](i)
    at(i)
  end

  def at(i)
    return nil unless i<@count
    @items[i] ||= GoogleBook.new(@list["items"][i]["id"])
  end

  def first
    at(0)
  end

end
