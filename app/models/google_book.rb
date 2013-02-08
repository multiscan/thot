require 'open-uri'

class GoogleBook
  def initialize(id)
    url="https://www.googleapis.com/books/v1/volumes/#{id}"
    @data=ActiveSupport::JSON.decode(open(url).read)
  end

  def id
    @data["id"]
  end
  def infolink
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
    @data["publisher"]
  end
  def pubyear
    @pubyear ||= parse_date(@data["publishedDate"])
  end
  def description
    @data["description"]
  end
  def collation
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
    @data["pageCount"]
  end
  def categories
    @data["categories"]
  end
  def tags
    unless @tags
      c=@data["categories"]
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
    @data["language"]
  end
  def imagelink
    images["large"] || images["medium"] || images["small"] || images["thumbnail"] || images["smallThumbnail"]
  end

 private

  def volinfo(i=0)
    @volinfo ||= @data["volumeInfo"] || {}
  end

  def authors
    volinfo["authors"] || []
  end

  def identifiers
    unless @identifiers
      @identifiers = {}
      (@data["industryIdentifiers"] || []).each do |i|
        @identifiers[i["type"]] = i["identifier"]
      end
    end
    @identifiers
  end

  def images
    @data["imageLinks"] || {}
  end

  def size
    unless @size
      dims=@data["dimensions"]
      h,w,t=dims["height"], dims["width"], dims["thickness"]
      p=[]
      p << "h: #{h}" if h
      p << "w: #{w}" if w
      p << "t: #{t}" if t
      @size = p.join(", ")
    end
    @size
  end

  # TODO:
  def parse_date(s)
    s
  end

end

class GoogleBookList
  def initialize(isbn)
    url="https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
    @list=ActiveSupport::JSON.decode(open(url).read)
    @count=@list["totalItems"]
    if @count > 0
      # WARNING: I keep only the first page...
      @count = @list["items"].size
      @items=Array.new(@count, nil)
    end
  end

  def count
    @count
  end

  def [i]
    return nil unless i<@count
    @items[i] ||= GoogleBook(@list[i]["id"])
  end

end
