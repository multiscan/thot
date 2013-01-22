module ApplicationHelper
  def long_text(t)
    t.gsub("\n", "<br/>").gsub("\t", "<span class='spacer'>&nbsp;</span>").html_safe;
  end

  # def item_status(item)
  #   item.user? ?
  #     case item.user.name
  #     when "Missing "
  #       "missing"
  #     when "mistery"
  #       "mistery"
  # end
end
