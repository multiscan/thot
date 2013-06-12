module ApplicationHelper
  def long_text(t)
    return "" if t.blank?
    t.gsub("\n", "<br/>").gsub("\t", "<span class='spacer'>&nbsp;</span>").html_safe;
  end

  def item_status(item)
    if item.status=="Library"
      if c=item.current_checkout
        "<span class='label label-warning'>on loan</span>".html_safe
      else
        "<span class='label label-success'>available</span>".html_safe
      end
    else
      "<span class='label label-inverse'>missing</span>".html_safe
    end
  end

  def item_price(item)
    item.price ? "#{item.price} #{item.currency}" :  "NA"
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
    will_paginate (v), :renderer => BootstrapPagination::Rails
  end

  class Prawn::Document
    TWO_OF_FIVE_ENCODING = [
      [0, 0, 1, 1, 0], [1, 0, 0, 0, 1], [0, 1, 0, 0, 1], [1, 1, 0, 0, 0], [0, 0, 1, 0, 1],
      [1, 0, 1, 0, 0], [0, 1, 1, 0, 0], [0, 0, 0, 1, 1], [1, 0, 0, 1, 0], [0, 1, 0, 1, 0],
    ]

    MM2P = 2.834645669291339

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

    # interleaved 2 of 5 barcode
    def inv_barcode(n, ox, oy, w, h)
      digits = n.to_s.split("").map{|d| d.to_i}
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
        lc=TWO_OF_FIVE_ENCODING[l]
        sc=TWO_OF_FIVE_ENCODING[s]
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
    end

    def label(item)
      w=bounds.right - bounds.left
      h=bounds.top - bounds.bottom
      bh=28.mm
      bw=24.mm
      # stroke_bounds
      bounding_box([(w-bw)/2, h-(h-bh)/2], :width => bw, :height => bh) do
        text item.lab.nick, :align => :center, :size => 12
        text item.book.call1 || "  ", :align => :center, :size => 12
        text item.book.call2 || "  ", :align => :center, :size => 12
        text item.book.call3 || "  ", :align => :center, :size => 12
        inv_barcode(item.inv, 4.mm, 24, 16.mm, 12)
        text_box "#{item.inv.to_s.split("").join(" ")}", :at => [4.mm, 8], :size => 8, :width => 16.mm, :align => :center
      end
      rotate(90, :origin => [0,0]) do
        inv_barcode(item.inv, (h-bh)/2, -2.mm, bh, (w-bw)/2-2.mm)
        inv_barcode(item.inv, (h-bh)/2, -w+(w-bw)/2, bh, (w-bw)/2-2.mm)
      end

    end

  end

end
