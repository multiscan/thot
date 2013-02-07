module ApplicationHelper
  def long_text(t)
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


end
