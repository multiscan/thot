module ApplicationHelper
  def long_text(t)
    t.gsub("\n", "<br/>").gsub("\t", "<span class='spacer'>&nbsp;</span>").html_safe;
  end

  def item_status(item)
    c=item.current_checkout
    if c
      ("On loan by " + link_to(c.user.name, c.user)).html_safe
    else
      item.status
    end
  end

  def item_price(item)
    item.price ? "#{item.price} #{item.currency}" :  "NA"
  end


end
