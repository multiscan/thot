class window.BookMerger
  constructor: (d) ->
    @mergendo = jQuery("#merger")
    return if @mergendo.length == 0

    console.debug("loading BookMerger")

    jQuery("#checkall").click (e) ->
      all_checks=jQuery("input[type='checkbox'][name='merge_book_ids[]']")
      all_checks.attr('checked', true)
      false
    jQuery("#uncheckall").click (e) ->
      all_checks=jQuery("input[type='checkbox'][name='merge_book_ids[]']")
      all_checks.attr('checked', false)
      false
    jQuery(".mergeable").click () ->
      cb = jQuery(this).children("input");
      cb.attr("checked", !cb.attr("checked"));
    jQuery(".mergeable .takeall").click (e) ->
      jQuery(this).parent().find("dd").click();
      false;
    jQuery(".mergeable dd").click (e) ->
      key=jQuery(this).attr("data-key")
      valnew=jQuery(this).text()
      id="#book_"+key
      cl="dd[data-key='"+key+"']"
      f = jQuery(id);
      valold=f.val();
      f.val(valnew);
      jQuery(cl).each (index) ->
        if (jQuery(this).text()==valnew)
          jQuery(this).addClass("selected")
          jQuery(this).removeClass("unselected")
        else
          jQuery(this).addClass("unselected")
          jQuery(this).removeClass("selected")
      false
