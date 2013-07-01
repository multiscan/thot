module ApplicationHelper
  def long_text(t)
    return "" if t.blank?
    t.gsub("\n", "<br/>").gsub("\t", "<span class='spacer'>&nbsp;</span>").html_safe;
  end

  def link_to_nebis(n)
    n=="empty" ? n : link_to(n, nebis_path(n))
  end

  def item_status(item)
    if item.status=="Library"
      if c=item.current_checkout
        "<span class='label label-warning'>on loan</span>".html_safe
      else
        "<span class='label label-success'>available</span>".html_safe
      end
    else
      "<span class='label label-inverse'>#{item.status}</span>".html_safe
    end
  end
  def full_item_status(item)
    if item.status=="Library"
      if c=item.current_checkout
        "<span class='label label-warning'>Library / on loan</span>".html_safe
      else
        "<span class='label label-success'>Library / available</span>".html_safe
      end
    else
      "<span class='label label-inverse'>#{item.status}</span>".html_safe
    end
  end

  def item_price(item)
    item.price ? "#{item.price} #{item.currency}" :  "NA"
  end

  def item_location(item)
    if item.location.blank?
      if item.shelf_id
        "Shelf id #{item.shelf_id}"
      else
        "NA"
      end
    else
      if item.shelf_id
        "#{item.location_name} / Shelf #{item.shelf.seqno}"
      else
        item.location_name
      end
    end
  end

  def days_ago(n)
    if n==0
      "today"
    elsif n==1
      "yesterday"
    elsif n<7
      "#{n} days ago"
    elsif n%7 == 0 && n<71
      "#{n/7} weeks ago"
    elsif n<71
      "more than #{(n/7).to_i} weeks ago"
    else
      "more than #{(n/30).to_i} months ago"
    end
  end

  def might_paginate(v)
    will_paginate v, :renderer => BootstrapPagination::Rails
  end

  def render_markdown(t)
    BlueCloth.new(t).to_html.html_safe
  end

  def print_labels_links(url)
    out = []
    out << link_to("3x8 label sheet with margins", url+".pdf?lf=3x8m")
    out << link_to("3x8 label sheet", url+".pdf?lf=3x8")
    out << link_to("dymo label printer", url+".pdf?lf=dymo")
    out.join(" | ").html_safe
  end

  class Prawn::Document

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

    def auto_grid_start(opts)
      define_grid(opts)
      @ag_nx = opts[:columns]
      @ag_ny = opts[:rows]
      @ag_ix = 0
      @ag_iy = 0
      @np = false
    end

    def auto_grid_next_bounding_box
      if @np
        start_new_page
        @np = false
      end
      grid(@ag_iy, @ag_ix).bounding_box do
        yield
      end
      @ag_ix = ( @ag_ix + 1 ) % @ag_nx
      if @ag_ix == 0
        @ag_iy = ( @ag_iy + 1 ) % @ag_ny
        @np = @ag_iy == 0
      end
    end

    # interleaved 2 of 5 barcode: http://en.wikipedia.org/wiki/Interleaved_2_of_5
    def barcode_25i(str, ox, oy, w, h, also_text=false)
      digits = str.split("").map{|d| d.to_i}
      digits.unshift 0 if digits.length%2 != 0
      tw = 9*(1+digits.size)    # total width in units of narrow bar width
      dw = w.to_f / tw          # narrow bar width
      ww=[dw, 3*dw]             # [narrow bar width, wide bar width]
      x = ox                    # pen position
      y = oy

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
        th = (h/5 > 6) ? h/5 : 6
        tw=1+(tw-9)*dw
        to=[ox+4*dw-1, oy-h+th]
        fill_color 0, 0, 0, 0
        fill_rectangle to, tw, th+1
        fill_color 0, 0, 0, 100
        text_box str.split("").join(" "), :at => to, :width => tw, :height => th, :align => :center, :valign => :bottom, :overflow => :shrink_to_fit
        # text_box str, :at => to, :width => tw, :height => th, :align => :center, :valign => :bottom, :overflow => :shrink_to_fit
      end

    end

    # TODO: implement a version using stamps. Possibly creating stamps on demand.
    def barcode_128(str, ox, oy, w, h, also_text=false)
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
        th = (h/5 > 6) ? h/5 : 6
        tw=1+(tw-24)*dw
        to=[ox+11*dw-1, oy-h+th]
        fill_color 0, 0, 0, 0
        fill_rectangle to, tw, th+1
        fill_color 0, 0, 0, 100
        text_box str.split("").join(" "), :at => to, :width => tw, :height => th, :align => :center, :valign => :bottom, :overflow => :shrink_to_fit
      end
    end

    def item_label(item)
      w=bounds.right - bounds.left
      h=bounds.top - bounds.bottom
      bh=28.mm
      bw=24.mm
      # stroke_bounds
      sid=item.id.to_s
      bounding_box([(w-bw)/2, h-(h-bh)/2], :width => bw, :height => bh) do
        text item.lab.nick, :align => :center, :size => 12
        text item.book.call1 || "  ", :align => :center, :size => 12
        text item.book.call2 || "  ", :align => :center, :size => 12
        text item.book.call3 || "  ", :align => :center, :size => 12
        barcode_25i(sid, 4.mm, 24, 16.mm, 24, true)
        # text_box "#{item.inv.to_s.split("").join(" ")}", :at => [4.mm, 8], :size => 8, :width => 16.mm, :align => :center
      end
      rotate(90, :origin => [0,0]) do
        barcode_25i(sid, (h-bh)/2, -2.mm, bh, (w-bw)/2-2.mm, false)
        barcode_25i(sid, (h-bh)/2, -w+(w-bw)/2, bh, (w-bw)/2-2.mm, true)
      end
    end

    def shelf_label(shelf)
      w=bounds.right - bounds.left
      h=bounds.top - bounds.bottom
      bh = h - 20 - 2.mm - 2.mm
      bw = w - 14.mm
      text_box "#{shelf.location.name} - SHELF #{shelf.seqno}", :at => [7.mm, h-2.mm], :width => bw, :height => 20, :size => 18, :align => :center, :valign => :top, :overflow => :shrink_to_fit
      barcode_128(sprintf("S %04d", shelf.id), 7.mm, bh+2.mm, bw, bh, true)
    end

  end

end
