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

end
