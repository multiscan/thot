require 'open-uri'

class LocBook
  def initialize(id)
    url="http://z3950.loc.gov:7090/voyager?version=1.1&operation=searchRetrieve&query=bath.isbn%3D#{id}&maximumRecords=1&recordSchema=mods"
    @isbn = id
    begin
      @xml=open(url).read
      @data=Ox.parse(@xml).locate("zs:searchRetrieveResponse/zs:records/zs:record/zs:recordData/mods")[0]
    rescue
      @data=nil
    end
  end
  def found?
    !@data.nil?
  end
  def id
    @isbn
  end
  def title
    return nil unless found?
    begin
      @title ||= @data.locate("titleInfo/title/?[0]")[0]
    rescue
      @title = ""
    end
    @title
  end
  def author
    return nil unless found?
    authors.join(", ")
  end
  def authors
    return [] unless found?
    begin
      @authors ||= @data.locate("name/namePart").select {|np| np.attributes[:type]!="date"}.map{|n| n.text}
    rescue
      @authors = []
    end
    @authors
  end
  def publisher
    return nil unless found?
    begin
      @publisher ||= @data.locate("originInfo/publisher")[0].text
    rescue
      @publisher = ""
    end
    @publisher
  end
  def pubyear
    return nil unless found?
    begin
      @pubyear ||= @data.locate("originInfo/dateIssued")[0].text.gsub(/[^0-9]*/, "")
    rescue
      @pubyear = nil
    end
    @pubyear
  end
  def series
    return nil unless found?
    begin
      @series ||= @data.locate("relatedItem").select{|r| r.locate("@type")[0]=="series"}[0].locate("titleInfo")[0].nodes[0].text
    rescue
      @series = nil
    end
    @series
  end
  def collation
    return nil unless found?
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
    return nil unless found?
    begin
      @lcc = @data.locate("classification").select{|ca| ca.attributes[:authority]=="lcc"}[0].text
    rescue
      @lcc = []
    end
    @lcc
  end
  def lcc_array
    return [] unless found?
    lcc.split(" ")
  end
  def call1
    return nil unless found?
    lcc_array[0].gsub(/^([A-Z]+).*$/, '\1')
  end
  def call2
    return nil unless found?
    lcc_array[0].gsub(/^[A-Z]*/, '')
  end
  def call3
    return nil unless found?
    lcc_array[1] || ""
  end
  def call4
    return nil unless found?
    lcc_array[2] || ""
  end
  def isbns
    return [] unless found?
    begin
      @isbns ||= @data.locate("identifier").select{|i| i.attributes[:type]=="isbn"}.map{|i| i.text.gsub(/ .*$/, '')}
    rescue
      @isbns = []
    end
    @isbns
  end
  def isbn_10
    return nil unless found?
    isbns.select {|n| n.length==10}.uniq[0]
  end
  def isbn_13
    return nil unless found?
    isbns.select {|n| n.length==13}.uniq[0]
  end
  def isbn
    return nil unless found?
    @isbn || isbn_10 || isbn_13
  end
  def lccn
    # library of congress number
    return nil unless found?
    begin
      @lccn ||= @data.locate("identifier").select{|i| i.attributes[:type]=="lccn"}[0].nodes[0]
    rescue
      @lccn = ""
    end
    @lccn
  end
  def uris
    return nil unless found?
    begin
      @uris ||= @data.locate("identifier").select{|i| i.attributes[:type]=="uri"}.map{|u| u.nodes[0]}
    rescue
      @uris = []
    end
    @uris
  end
  def toc_uri
    return nil unless found?
    uris.select{ |u| u =~ /-t.html/ }[0]
    # @data.locate("location/url").select{|u| u.attributes[:displayLabel]=~/content/}[0].nodes[0]
  end
  def desc_uri
    return nil unless found?
    uris.select{ |u| u =~ /-d.html/ }[0]
    # @data.locate("location/url").select{|u| u.attributes[:displayLabel]=~/desciption/}[0].nodes[0]
  end

  def to_h
    return {} unless found?
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

 private
end
