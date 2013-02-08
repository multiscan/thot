require 'open-uri'

# google book moved to model

def query_open_library(isbn)
  if d = Openlibrary::Data.find_by_isbn(isbn)
    book=Book.new
    book.title = (d.title || "") + (d.subtitle || "") if d.title || d.subtitle
    book.author = d.authors.map{|a| a["name"]}.join(", ") if d.authors
    book.publisher_name = d.publishers.first["name"] if d.publishers
    book.pubyear = d.publish_date.gsub(/^.*,/,"").strip.to_i

    book.isbn = d.identifiers["isbn_10"] ? d.identifiers["isbn_10"].first : ( d.identifiers["isbn_13"] ? d.identifiers["isbn_13"].first : isbn ) if d.identifiers
  end
end

def locxml(isbn, schema="mods")
  url="http://z3950.loc.gov:7090/voyager?version=1.1&operation=searchRetrieve&query=bath.isbn%3D#{isbn}&maximumRecords=1&recordSchema=#{schema}"
  open(url).read
end



def query_loc2(isbn)
  schema="mods"
  url="http://z3950.loc.gov:7090/voyager?version=1.1&operation=searchRetrieve&query=bath.isbn%3D#{isbn}&maximumRecords=1&recordSchema=#{schema}"
  xml=open(url).read
  h=Hash.from_xml(xml)
  puts "------------------------------------------------------------------------"
  puts xml
  puts "------------------------------------------------------------------------"
  p h
  puts "------------------------------------------------------------------------"
  b=Book.new
end

def query_loc(isbn)
  xml=locxml(isbn, "mods")
  doc=Nokogiri::XML(xml)
  puts "------------------------------------------------------------------------"
  puts xml
  puts "------------------------------------------------------------------------"
end


# --------------- schema: dc
#   <title>Sociology--a brief introduction /</title>
#   <creator>Schaefer, Richard T.</creator>
#   <creator>Lamm, Robert P.</creator>
#   <type>text</type>
#   <publisher>New York : McGraw-Hill,</publisher>
#   <date>c1994.</date>
#   <language>eng</language>
#   <description>Includes bibliographical references (p. 385-409) and indexes.</description>
#   <subject>Sociology.</subject>
#   <coverage>United States--Social conditions--1980-</coverage>
#   <identifier>URN:ISBN:0070550336 (alk. paper)</identifier>

# --------------- schema: mods
#   <titleInfo>
#     <title>Sociology--a brief introduction</title>
#   </titleInfo>
#   <name type="personal">
#     <namePart>Schaefer, Richard T.</namePart>
#     <role>
#       <roleTerm authority="marcrelator" type="text">creator</roleTerm>
#     </role>
#   </name>
#   <name type="personal">
#     <namePart>Lamm, Robert P.</namePart>
#   </name>
#   <typeOfResource>text</typeOfResource>
#   <genre authority="marcgt">bibliography</genre>
#   <originInfo>
#     <place>
#       <placeTerm type="code" authority="marccountry">nyu</placeTerm>
#     </place>
#     <place>
#       <placeTerm type="text">New York</placeTerm>
#     </place>
#     <publisher>McGraw-Hill</publisher>
#     <dateIssued>c1994</dateIssued>
#     <dateIssued encoding="marc">1994</dateIssued>
#     <issuance>monographic</issuance>
#   </originInfo>
#   <language>
#     <languageTerm authority="iso639-2b" type="code">eng</languageTerm>
#   </language>
#   <physicalDescription>
#     <form authority="marcform">print</form>
#     <extent>xviii, 424 p. : ill. (mostly col.), col. maps ; 26 cm.</extent>
#   </physicalDescription>
#   <note type="statement of responsibility">Richard T. Schaefer, Robert P. Lamm.</note>
#   <note>Includes bibliographical references (p. 385-409) and indexes.</note>
#   <subject>
#     <geographicCode authority="marcgac">n-us---</geographicCode>
#   </subject>
#   <subject authority="lcsh">
#     <topic>Sociology</topic>
#   </subject>
#   <subject authority="lcsh">
#     <geographic>United States</geographic>
#     <topic>Social conditions</topic>
#     <temporal>1980-</temporal>
#   </subject>
#   <classification authority="lcc">HM51 .S345 1994</classification>
#   <classification authority="ddc" edition="20">301</classification>
#   <identifier type="isbn">0070550336 (alk. paper)</identifier>
#   <identifier type="lccn">93009830</identifier>
#   <recordInfo>
#     <recordContentSource authority="marcorg">DLC</recordContentSource>
#     <recordCreationDate encoding="marc">930219</recordCreationDate>
#     <recordChangeDate encoding="iso8601">19960119195406.1</recordChangeDate>
#     <recordIdentifier>3941182</recordIdentifier>
#   </recordInfo>

# --------------- schema: marcxml
# <record xmlns="http://www.loc.gov/MARC21/slim">
#   <leader>01039cam a2200289 a 4500</leader>
#   <controlfield tag="001">3941182</controlfield>
#   <controlfield tag="005">19960119195406.1</controlfield>
#   <controlfield tag="008">930219s1994    nyuab    b    001 0 eng  </controlfield>
#   <datafield tag="035" ind1=" " ind2=" ">
#     <subfield code="9">(DLC)   93009830</subfield>
#   </datafield>
#   <datafield tag="906" ind1=" " ind2=" ">
#     <subfield code="a">7</subfield>
#     <subfield code="b">cbc</subfield>
#     <subfield code="c">orignew</subfield>
#     <subfield code="d">1</subfield>
#     <subfield code="e">ocip</subfield>
#     <subfield code="f">19</subfield>
#     <subfield code="g">y-gencatlg</subfield>
#   </datafield>
#   <datafield tag="955" ind1=" " ind2=" ">
#     <subfield code="a">pc14 to sc00 02-19-93; sd21/sd08 02-27-93; sd53 03-04-93;aa05 03-09-93; CIP ver sb24 08-31-93</subfield>
#   </datafield>
#   <datafield tag="010" ind1=" " ind2=" ">
#     <subfield code="a">   93009830 </subfield>
#   </datafield>
#   <datafield tag="020" ind1=" " ind2=" ">
#     <subfield code="a">0070550336 (alk. paper)</subfield>
#   </datafield>
#   <datafield tag="040" ind1=" " ind2=" ">
#     <subfield code="a">DLC</subfield>
#     <subfield code="c">DLC</subfield>
#     <subfield code="d">DLC</subfield>
#   </datafield>
#   <datafield tag="043" ind1=" " ind2=" ">
#     <subfield code="a">n-us---</subfield>
#   </datafield>
#   <datafield tag="050" ind1="0" ind2="0">
#     <subfield code="a">HM51</subfield>
#     <subfield code="b">.S345 1994</subfield>
#   </datafield>
#   <datafield tag="082" ind1="0" ind2="0">
#     <subfield code="a">301</subfield>
#     <subfield code="2">20</subfield>
#   </datafield>
#   <datafield tag="100" ind1="1" ind2=" ">
#     <subfield code="a">Schaefer, Richard T.</subfield>
#   </datafield>
#   <datafield tag="245" ind1="1" ind2="0">
#     <subfield code="a">Sociology--a brief introduction /</subfield>
#     <subfield code="c">Richard T. Schaefer, Robert P. Lamm.</subfield>
#   </datafield>
#   <datafield tag="260" ind1=" " ind2=" ">
#     <subfield code="a">New York :</subfield>
#     <subfield code="b">McGraw-Hill,</subfield>
#     <subfield code="c">c1994.</subfield>
#   </datafield>
#   <datafield tag="300" ind1=" " ind2=" ">
#     <subfield code="a">xviii, 424 p. :</subfield>
#     <subfield code="b">ill. (mostly col.), col. maps ;</subfield>
#     <subfield code="c">26 cm.</subfield>
#   </datafield>
#   <datafield tag="504" ind1=" " ind2=" ">
#     <subfield code="a">Includes bibliographical references (p. 385-409) and indexes.</subfield>
#   </datafield>
#   <datafield tag="650" ind1=" " ind2="0">
#     <subfield code="a">Sociology.</subfield>
#   </datafield>
#   <datafield tag="651" ind1=" " ind2="0">
#     <subfield code="a">United States</subfield>
#     <subfield code="x">Social conditions</subfield>
#     <subfield code="y">1980-</subfield>
#   </datafield>
#   <datafield tag="700" ind1="1" ind2=" ">
#     <subfield code="a">Lamm, Robert P.</subfield>
#   </datafield>
#   <datafield tag="922" ind1=" " ind2=" ">
#     <subfield code="a">ad</subfield>
#   </datafield>
#   <datafield tag="991" ind1=" " ind2=" ">
#     <subfield code="b">c-GenColl</subfield>
#     <subfield code="h">HM51</subfield>
#     <subfield code="i">.S345 1994</subfield>
#     <subfield code="p">00012535521</subfield>
#     <subfield code="t">Copy 1</subfield>
#     <subfield code="w">BOOKS</subfield>
#   </datafield>
# </record>
