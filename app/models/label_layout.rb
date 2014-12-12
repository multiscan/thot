# all measures in mm to be translated into pts
# pw : page width
# ph : page height
# nr : number of label rows
# nc : number of label columns
# mt : margin top
# mb : margin bottom
# ml : margin left
# mr : margin right
# hs : horizontal spacing
# vs : vertical spacing
# vp : virtical padding
# hp : horizontal padding

class LabelLayout < ActiveRecord::Base

  MM2PT = 2.834645669  # mm to typographic points (1inch = 72pt)

  STANDARD_PAGE_SIZES = {
    "A4" => [210, 297],
    "A3" => [297, 410],
    "Letter" => [216, 279],
    "Legal" => [216, 356]
  }

  validates_presence_of :pw, :message => "can't be blank. Please set or select a page format"
  validates_presence_of :ph, :message => "can't be blank. Please set or select a page format"
  validates_presence_of :nr, :message => "can't be blank"
  validates_presence_of :nc, :message => "can't be blank"

  def page=(s)
    if STANDARD_PAGE_SIZES.has_key?(s)
      ss=STANDARD_PAGE_SIZES[s]
      self.pw = ss[0]
      self.ph = ss[1]
    end
  end

  def page
    STANDARD_PAGE_SIZES.key?([self.pw, self.ph]) || begin
      if self.pw.nil? || self.ph.nil?
        nil
      else
        "custom"
      end
    end
  end

  def page_params
    {
      page_size: self.page_size,
      margin: self.page_margin,
      page_layout: :portrait,
    }
  end

  def grid_params
    {
      columns: self.nc,
      rows: self.nr,
      row_gutter: self.row_gutter,
      column_gutter: self.column_gutter
    }
  end

  def label_w_mm
    @label_w_mm ||= (pw - ml - mr - (nc - 1) * hs).to_f/nc
  end

  def label_h_mm
    @label_h_mm ||= (ph - mt - mb - (nr - 1) * vs).to_f/nr
  end

  def label_w
    @label_w ||= MM2PT * label_w_mm
  end

  def label_h
    @label_h ||= MM2PT * label_h_mm
  end

  # writable box width/height
  def box_w_mm
    @box_w_mm ||= label_w_mm - 2 * hp
  end

  def box_h_mm
    @box_h_mm ||= label_h_mm - 2 * vp
  end

  # writable box width/height
  def box_w
    @box_w ||= MM2PT*box_w_mm
  end

  def box_h
    @box_h ||= MM2PT*box_h_mm
  end

  # gutter is the distance between rows of writable boxes
  def column_gutter
    @row_gutter ||= MM2PT*(hs + 2 * hp)
  end

  def row_gutter
    @row_gutter ||= MM2PT*(vs + 2 * vp)
  end

  # page size as required by prawn (predefined page name or custom dimensions)
  def page_size
    @page_size ||= [pw, ph].map{|d| d*MM2PT}
  end

  def page_margin_mm
    @page_margin_mm ||= [mt+vp, mr+hp, mb+vp, ml+hp]
  end

  def page_margin
    @page_margin ||= page_margin_mm.map{|d| d*MM2PT}
  end


  def pretty_print
    puts "---------------------------------------- #{name}"
    puts "Page:    #{pw} x #{ph}"
    puts "Margins: #{page_margin_mm.join(' ')}"
    puts "Grid:    #{nc} x #{nr}"
    puts "HSpace:  #{hp} + #{column_gutter/MM2PT} + #{hp}"
    puts "VSpace:  #{vp} + #{row_gutter/MM2PT} + #{vp}"
    puts "Label:   #{label_w_mm} x #{label_h_mm}"
    puts "Box:     #{box_w/MM2PT} x #{box_h/MM2PT}"
    puts "------------------------------"
  end

end

# TODO This should probably go in a separate file into lib
require "prawn/measurement_extensions"
class PrawnLabelSheet
  include Prawn::View

  MM2PT = 2.834645669
  CM2PT = 10 * MM2PT
  PT2MM = 1.0 / MM2PT
  PT2CM = 1.0 / CM2PT

  CODE25 = [
    [0, 0, 1, 1, 0], [1, 0, 0, 0, 1], [0, 1, 0, 0, 1], [1, 1, 0, 0, 0], [0, 0, 1, 0, 1],
    [1, 0, 1, 0, 0], [0, 1, 1, 0, 0], [0, 0, 0, 1, 1], [1, 0, 0, 1, 0], [0, 1, 0, 1, 0],
  ]

  CODE128 = [
    "212222", "222122", "222221", "121223", "121322", "131222", "122213", "122312",
    "132212", "221213", "221312", "231212", "112232", "122132", "122231", "113222",
    "123122", "123221", "223211", "221132", "221231", "213212", "223112", "312131",
    "311222", "321122", "321221", "312212", "322112", "322211", "212123", "212321",
    "232121", "111323", "131123", "131321", "112313", "132113", "132311", "211313",
    "231113", "231311", "112133", "112331", "132131", "113123", "113321", "133121",
    "313121", "211331", "231131", "213113", "213311", "213131", "311123", "311321",
    "331121", "312113", "312311", "332111", "314111", "221411", "431111", "111224",
    "111422", "121124", "121421", "141122", "141221", "112214", "112412", "122114",
    "122411", "142112", "142211", "241211", "221114", "413111", "241112", "134111",
    "111242", "121142", "121241", "114212", "124112", "124211", "411212", "421112",
    "421211", "212141", "214121", "412121", "111143", "111341", "131141", "114113",
    "114311", "411113", "411311", "113141", "114131", "311141", "411131", "211412",
    "211214", "211232", "2331112"
  ]

  def initialize(l, t="Thot librarian printout")
    @layout = l
    @title  = t
  end

  def document
    doc_params = @layout.page_params.merge( {
      info: {
              :Title => @title,
              :Author => "Thot library system",
              :Subject => "Printable Labels for Library Books",
              :Creator => "thot.epfl.ch",
              :Producer => "EPFL",
              :CreationDate => Time.now
            },
      print_scaling: :none
    })
    @document ||= Prawn::Document.new(doc_params)
  end

  def preview
    first=true
    # stroke_circle [0, 0], 2
    # stroke_circle [0, 0], @layout.box_w
    # stroke_rectangle [0, bounds.top], (bounds.right - bounds.left), (bounds.top - bounds.bottom)
    # stroke_circle [@layout.label_w - @layout.column_gutter, 0], @layout.hp.mm
    # stroke_circle [@layout.label_w - @layout.column_gutter, 0], @layout.column_gutter/2
    # stroke_circle [@layout.label_w - 2 * @layout.hp.mm, 0], @layout.hp.mm
    auto_grid_start
    (1..@layout.nr).each do |ir|
      (1..@layout.nc).each do |ic|
        auto_grid_next_bounding_box(true) {
          w = (bounds.right - bounds.left)
          h = (bounds.top - bounds.bottom)
          sw = ((w-4*MM2PT)*PT2CM).to_i
          sh = ((h-4*MM2PT)*PT2CM).to_i
          stroke_size_ref(2.mm, 2.mm, sw, sh)
          if first
            text_box "The grey rectangle represent the area that will be printed (~2 mm inside the actual label). The ticks on the left should represent centimeters unless your printer is arbitrarily scaling the pdf.", :at => [10.mm, h-5.mm], :width => w-15.mm, :height => h-10.mm, :align => :left, :valign => :top, :overflow => :shrink_to_fit
            first = false
          end
        }
      end
    end
    (0..@layout.nr).each do |ir|
      (0..@layout.nc).each do |ic|
        stroke_circle [ic*@layout.label_w - 0.5*@layout.column_gutter, ir*@layout.label_h - 0.5*@layout.row_gutter], 2
      end
    end
  end


  def auto_grid_start(opts=@layout.grid_params)
    define_grid(opts)
    @ag_nx = opts[:columns]
    @ag_ny = opts[:rows]
    @ag_ix = 0
    @ag_iy = 0
    @np = false
  end

  def auto_grid_next_bounding_box(print_bounds=Rails.env.development?)
    if @np
      start_new_page
      @np = false
    end
    # grid(@ag_iy, @ag_ix).show
    grid(@ag_iy, @ag_ix).bounding_box do
      if print_bounds
        stroke_color "cccccc"
        stroke_bounds
        stroke_color "000000"
        # transparent(0.1) {stroke_bounds}
        # stroke_axis_without_text(at: [2.mm, 2.mm], height: 25.mm, width: 5.cm, step_length: 1.cm, negative_axes_length: 0)
      end
      yield
    end
    @ag_ix = ( @ag_ix + 1 ) % @ag_nx
    if @ag_ix == 0
      @ag_iy = ( @ag_iy + 1 ) % @ag_ny
      @np = @ag_iy == 0
    end
  end

  # interleaved 2 of 5 barcode: http://en.wikipedia.org/wiki/Interleaved_2_of_5
  def barcode_25i(str, ox, oy, w, hh, also_text=false)
    digits = str.split("").map{|d| d.to_i}
    digits.unshift 0 if digits.length%2 != 0
    tw = 9*(1+digits.size)    # total width in units of narrow bar width
    dw = w.to_f / tw          # narrow bar width
    ww=[dw, 3*dw]             # [narrow bar width, wide bar width]
    x = ox                    # pen position
    y = oy
    h = hh-0.2

    # begin (nnnn)
    fill_rectangle [x,y], ww[0], h
    x = x + ww[0] + ww[0]
    fill_rectangle [x,y], ww[0], h
    x = x + ww[0] + ww[0]

    # number
    (digits.length/2).times do
      l,s=digits.shift(2)
      lc=CODE25[l]
      sc=CODE25[s]
      0.upto(4) do |i|
        lw=ww[lc[i]]
        sw=ww[sc[i]]
        fill_rectangle [x,y], lw, h
        x = x + lw + sw
      end
    end

    # end (wnn)
    fill_rectangle [x,y], ww[1], h
    x = x + ww[1] + ww[0]
    fill_rectangle [x,y], ww[0], h

    if also_text
      th = (hh/5 > 6) ? hh/5 : 6
      tw=1+(tw-9)*dw
      to_txt=[ox+4*dw-1, oy-hh+th]
      to_bgb=[ox+4*dw-1, oy-hh+th+5]
      fill_color 0.0, 0, 0, 0
      fill_rectangle to_bgb, tw, th+5
      fill_color 0, 0, 0, 100
      text_box str.split("").join(" "), :at => to_txt, :width => tw, :height => th, :align => :center, :valign => :bottom, :overflow => :shrink_to_fit
    end

  end

  # TODO: implement a version using stamps. Possibly creating stamps on demand.
  def barcode_128(str, ox, oy, w, hh, also_text=false)
    digits = [104] # Start Code B
    str.gsub(/[^ a-zA-Z0-9!"#$\%&'()*+,\-.\/:;<=>?@]+/, "").each_byte {|b| digits << b-32}
    # control char is ( start + sum(d*pos(d))) % 103
    cc=digits[0]
    ww=[digits[0]]
    1.upto(digits.size-1) {|i| cc = cc + i * digits[i]; ww << (i * digits[i])}
    cc = cc % 103
    digits << cc
    digits << 106  # stop
    tw = 11*digits.size + 2 # tot width in dw units (stop have 2 extra narrowest lines)
    dw = w.to_f / tw        # narrowest line width in units of w (points)
    h = hh - 0.2
    x = ox
    y = oy

    digits.each do |d|
      black=true
      CODE128[d].each_char do |c|
        dx=c.to_i*dw
        fill_rectangle [x,y], dx, h if black
        x = x + dx
        black = !black
      end
    end
    if also_text
      th = (hh/5 > 6) ? hh/5 : 6
      tw=1+(tw-24)*dw
      to_txt=[ox+4*dw-1, oy-hh+th]
      to_bgb=[ox+4*dw-1, oy-hh+th+5]
      fill_color 0, 0, 0, 0
      fill_rectangle to_bgb, tw, th+5
      fill_color 0, 0, 0, 100
      text_box str.split("").join(" "), :at => to_txt, :width => tw, :height => th, :align => :center, :valign => :bottom, :overflow => :shrink_to_fit
    end
  end

  def item_label(item)
    sid=item.id.to_s

    fs=12                             # font size
    cw=14.mm                          # width of the center part
    sm=4.mm                           # margin between center and side boxes
    bch=18.mm                         # center barcode height
    bcm=1.mm                          # center barcode top margin

    left_lines = [
      item.lab.nick,
      item.book.call1 || "",
      item.book.call2 || "",
      item.book.call3 || "",
      item.book.call4 || "",
      " ",
      sid
    ].map{|l| l.truncate(12, omission: "...")}
    center_lines = [
      item.lab.nick,
      (item.book.call1 || "") + " " + (item.book.call2 || ""),
      item.book.call3 || "",
    ].map{|l| l.truncate(9, omission: "")}

    w = bounds.right - bounds.left
    h = bounds.top - bounds.bottom
    hw = 0.5 * w                     # half width
    sw = (w - cw) / 2 - sm           # sidebox width

    # ---                                                             --- draw
    font_size(fs)
    y = h
    x = 0

    text_box(left_lines.join("\n"), at: [x,y], width: sw, height: h, :align => :left, :overflow => :shrink_to_fit, disable_wrap_by_char: true)
    x = hw - 0.5*cw
    text_box(center_lines.join("\n"), at: [x,y], width: cw, height: h-bch-bcm, :align => :left, :overflow => :shrink_to_fit, disable_wrap_by_char: true)
    rotate(90, :origin => [x,0]) do
      barcode_25i(sid, x, 0, bch, cw, false)
    end
    rw = [0.75 * sw, 20.mm].min
    x = w - rw
    rotate(90, :origin => [x,0]) do
      barcode_25i(sid, x, 0, h, rw, true)
    end
  end

  # use only top ~1.5 cm of the label for it to be sticket to the shelf
  def shelf_label(shelf)
    w=bounds.right - bounds.left
    h=bounds.top - bounds.bottom
    bh = 15.mm
    bw = w - 44.mm
    th = 15.mm
    tw = 40.mm
    font "Helvetica", :style => :bold
    text_box "#{shelf.seqno}", :at => [2.mm, h-2.mm], :width => tw, :height => th, :size => 190, :align => :center, :valign => :top, :overflow => :shrink_to_fit, disable_wrap_by_char: true
    font "Helvetica", :style => :normal
    barcode_128(sprintf("S %04d", shelf.id), 42.mm, h-2.mm, bw, bh, true)
  end

  def stroke_size_ref(ox, oy, w, h)
    stroke_horizontal_line(ox, ox + w*CM2PT, :at => oy)
    stroke_vertical_line(oy, oy + h*CM2PT, :at => ox)
    t=1*MM2PT
    (1..w).each do |i|
      stroke_vertical_line(oy-t, oy+t, :at => (ox + i*CM2PT) )
    end
    (1..h).each do |i|
      stroke_horizontal_line(ox-t, ox+t, :at => (oy + i*CM2PT) )
    end
  end

end
