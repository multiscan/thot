li=jQuery("#loan_li_<%= @loan.id %>").first()
console.log("------- destroy.js: li="+li)
thot.scrollTo(li)
li.css("background-color", "#b94a48")
li.fadeOut 'slow', ->
  console.log("in fadeout: this=" + $(this))
  $(this).remove();
  if (jQuery(".bookli").size() == 0)
    $("#emptybooklist").show()
