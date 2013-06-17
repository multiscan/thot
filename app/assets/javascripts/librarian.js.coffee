class window.Librarian
  constructor: () ->
    @nebis = gon.nebis
    @reset_url = "/nebis/@nebis"

    $(document).on "barcode_nebis", (e) => @on_nebis(e.message)
    $(document).on "barcode_item", (e) => @on_item(e.message)

  on_nebis: (nebis) ->
    console.log("catched barcode_nebis: %s", nebis)
    if @nebis && @nebis == nebis
      inactivity_monitor.reset()
    else
      location.href = "/nebis/"+nebis

  on_item_when_logged_in: (item) ->
    console.log("catched barcode_book: %s", item)
    if @nebis
      return_link = jQuery('a[data-inv='+item+']')
      if return_link.size()==0
        console.log("the book is not in the list. Checking out")
        jQuery('#loan_inv').val(inv)
        jQuery('#new_loan .btn').click()
      else
        console.log("the book is already in the list. Returning it")
        return_link[0].click()
    else
      thot.alert("info", "Please scan your nebis code before scanning any book label")
