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


  class Prawn::Document
    TWO_OF_FIVE_ENCODING = [
      [0, 0, 1, 1, 0], [1, 0, 0, 0, 1], [0, 1, 0, 0, 1], [1, 1, 0, 0, 0], [0, 0, 1, 0, 1],
      [1, 0, 1, 0, 0], [0, 1, 1, 0, 0], [0, 0, 0, 1, 1], [1, 0, 0, 1, 0], [0, 1, 0, 1, 0],
    ]

    def auto_grid_start(opts)
      define_grid(opts)
      @ag_nx = opts[:columns]
      @ag_ny = opts[:rows]
      @ag_ix = 0
      @ag_iy = 0
    end

    def auto_grid_next_bounding_box
      grid(@ag_iy, @ag_ix).bounding_box do

        yield
      end
      @ag_ix = ( @ag_ix + 1 ) % @ag_nx
      if @ag_ix == 0
        @ag_iy = ( @ag_iy + 1 ) % @ag_ny
        start_new_page if @ag_iy == 0
      end
    end

    # interleaved 2 of 5 barcode
    def inv_barcode(n, w, h)
      digits = n.to_s.split("").map{|d| d.to_i}
      digits.unshift 0 if digits.length%2 != 0
      tw = 9*(1+digits.size)
      dw = w.to_f / tw
      puts "dw=#{dw}"

      ww=[dw, 3*dw]
      x=0

      # begin (nnnn)
      fill_rectangle [x,0], ww[0], h
      x = x + ww[0] + ww[0]
      fill_rectangle [x,0], ww[0], h
      x = x + ww[0] + ww[0]

      # number
      (digits.length/2).times do
        l,s=digits.shift(2)
        lc=TWO_OF_FIVE_ENCODING[l]
        sc=TWO_OF_FIVE_ENCODING[s]
        0.upto(4) do |i|
          lw=ww[lc[i]]
          sw=ww[sc[i]]
          fill_rectangle [x,0], lw, h
          x = x + lw + sw
        end
      end

      # end (wnn)
      fill_rectangle [x,0], ww[1], h
      x = x + ww[1] + ww[0]
      fill_rectangle [x,0], ww[0], h
    end

    def inv_barcode_size(n)
      9*(1+(n+1)/2)
    end
  end

end
