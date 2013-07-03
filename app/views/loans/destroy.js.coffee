# for loans listing
li=jQuery("#loan_li_<%= @loan.id %>").first()
if li.length > 0
  thot.scrollTo(li)
  li.css("background-color", "#b94a48")
  li.fadeOut 'slow', ->
    $(this).remove();
    if (jQuery(".bookli").size() == 0)
      $("#emptybooklist").show()
# For items listing
a=jQuery("#on_loan_<%= @loan.id %>").first()
if a.length > 0
  a.popover('hide')
  a.replaceWith("<span class='label label-success'>available</span>")

