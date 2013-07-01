require 'open-uri'

class LocBook
  def initialize(id)
    url="http://z3950.loc.gov:7090/voyager?version=1.1&operation=searchRetrieve&query=bath.isbn%3D#{id}&maximumRecords=1&recordSchema=mods"
    @xml=open(url).read
    @data=Ox.parse(@xml).locate("zs:searchRetrieveResponse/zs:records/zs:record/zs:recordData/mods")[0]
    @isbn = id
  end
  def found?
    !@data.nil?
  end
  def id
    @isbn
  end
  def title
    begin
      @title ||= @data.locate("titleInfo/title/?[0]")[0]
    rescue
      @title = ""
    end
    @title
  end
  def author
    authors.join(", ")
  end
  def authors
    begin
      @authors ||= @data.locate("name/namePart").select {|np| np.attributes[:type]!="date"}.map{|n| n.text}
    rescue
      @authors = []
    end
    @authors
  end
  def publisher
    begin
      @publisher ||= @data.locate("originInfo/publisher")[0].text
    rescue
      @publisher = ""
    end
    @publisher
  end
  def pubyear
    begin
      @pubyear ||= @data.locate("originInfo/dateIssued")[0].text.gsub(/[^0-9]*/, "")
    rescue
      @pubyear = nil
    end
    @pubyear
  end
  def series
    begin
      @series ||= @data.locate("relatedItem").select{|r| r.locate("@type")[0]=="series"}[0].locate("titleInfo")[0].nodes[0].text
    rescue
      @series = nil
    end
    @series
  end
  def collation
    begin
      @collation ||= @data.locate("physicalDescription/extent")[0].text
    rescue
      @collation = ""
    end
    @collation
  end

  # lcc text should be of the form:
  # 'QA166.17 .R34 1992' -> [QA, 166.17, .R34, 1992] = [call1, call2, call3, call4]
  #
  def lcc
    begin
      @lcc = @data.locate("classification").select{|ca| ca.attributes[:authority]=="lcc"}[0].text
    rescue
      @lcc = []
    end
    @lcc
  end
  def lcc_array
    lcc.split(" ")
  end
  def call1
    lcc_array[0].gsub(/^([A-Z]+).*$/, '\1')
  end
  def call2
    lcc_array[0].gsub(/^[A-Z]*/, '')
  end
  def call3
    lcc_array[1] || ""
  end
  def call4
    lcc_array[2] || ""
  end
  def isbns
    begin
      @isbns ||= @data.locate("identifier").select{|i| i.attributes[:type]=="isbn"}.map{|i| i.text.gsub(/ .*$/, '')}
    rescue
      @isbns = []
    end
    @isbns
  end
  def isbn_10
    isbns.select {|n| n.length==10}.uniq[0]
  end
  def isbn_13
    isbns.select {|n| n.length==13}.uniq[0]
  end
  def isbn
    @isbn || isbn_10 || isbn_13
  end
  def lccn
    # library of congress number
    begin
      @lccn ||= @data.locate("identifier").select{|i| i.attributes[:type]=="lccn"}[0].nodes[0]
    rescue
      @lccn = ""
    end
    @lccn
  end
  def uris
    begin
      @uris ||= @data.locate("identifier").select{|i| i.attributes[:type]=="uri"}.map{|u| u.nodes[0]}
    rescue
      @uris = []
    end
    @uris
  end
  def toc_uri
    uris.select{ |u| u =~ /-t.html/ }[0]
    # @data.locate("location/url").select{|u| u.attributes[:displayLabel]=~/content/}[0].nodes[0]
  end
  def desc_uri
    uris.select{ |u| u =~ /-d.html/ }[0]
    # @data.locate("location/url").select{|u| u.attributes[:displayLabel]=~/desciption/}[0].nodes[0]
  end

  def to_h
    b = {
        :title => title,
        :isbn => isbn,
        :pubyear => pubyear,
        :author => author,
        :publisher_name => publisher,
        # :abstract => description,
        :collation => collation,
        # :lccn => lccn,
        # :isbn_13 => isbn_13,
        :call1 => call1,
        :call2 => call2,
        :call3 => call3,
        :call4 => call4,
        :collection => series
    }
    return b
  end

  # def subtitle
  #   volinfo["subtitle"]
  # end
  # def author
  #   volinfo["authors"].join(", ")
  # end
  # def description
  #   volinfo["description"]
  # end
  # def collation
  #   unless @collation
  #     p=[]
  #     p << "#{pages} pages" if pages
  #     p << size unless size.empty?
  #     @collation = p.join("; ")
  #   end
  #   @collation
  # end
  # def isbn_10
  #   identifiers["ISBN_10"]
  # end
  # def isbn_13
  #   identifiers["ISBN_13"]
  # end
  # def isbn
  #   isbn_10 || isbn_13
  # end
  # def pages
  #   volinfo["pageCount"]
  # end
  # def categories
  #   volinfo["categories"]
  # end
  # def tags
  #   unless @tags
  #     c=volinfo["categories"]
  #     if c
  #       t=[]
  #       c.each {|cc| t += cc.split("/")}
  #       t.delete("General")
  #       @tags = t.sort.uniq
  #     else
  #       @tags=[]
  #     end
  #   end
  #   @tags
  # end
  # def language
  #   volinfo["language"]
  # end

  # def imagelink
  #   images["large"] || images["medium"] || images["small"] || images["thumbnail"] || images["smallThumbnail"]
  # end


 private

#   def volinfo(i=0)
#     @volinfo ||= @data["volumeInfo"] || {}
#   end

#   def authors
#     volinfo["authors"] || []
#   end

#   def identifiers
#     unless @identifiers
#       @identifiers = {}
#       (volinfo["industryIdentifiers"] || []).each do |i|
#         @identifiers[i["type"]] = i["identifier"]
#       end
#     end
#     @identifiers
#   end

#   def images
#     volinfo["imageLinks"] || {}
#   end

#   def size
#     unless @size
#       dims=volinfo["dimensions"]
#       if dims
#         h,w,t=dims["height"], dims["width"], dims["thickness"]
#         p=[]
#         p << "h: #{h}" if h
#         p << "w: #{w}" if w
#         p << "t: #{t}" if t
#         @size = p.join(", ")
#       else
#         @size = ""
#       end
#     end
#     @size
#   end

#   # TODO:
#   def parse_date(s)
#     s ? s.gsub(/^.*([0-9][0-9][0-9][0-9]).*$/, '\1').to_i : nil
#   end
end

# class LocBookList
#   def initialize(isbn)
#     url="https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}"
#     @list=ActiveSupport::JSON.decode(open(url).read)
#     @count=@list["totalItems"]
#     if @count > 0
#       # WARNING: I keep only the first page...
#       @count = @list["items"].size
#       @items=Array.new(@count, nil)
#     end
#   end

#   def all
#     @items.each_index {|i| at(i)}
#     @items
#   end

#   def to_ah
#     all.map {|i| i.to_h}
#   end

#   def count
#     @count
#   end

#   def [](i)
#     at(i)
#   end

#   def at(i)
#     return nil unless i<@count
#     @items[i] ||= LocBook.new(@list["items"][i]["id"])
#   end

#   def first
#     at(0)
#   end

# end
