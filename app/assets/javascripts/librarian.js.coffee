class window.Librarian
  constructor: () ->
    @nebis = gon.nebis
    @reset_url = "/nebis/@nebis"

    console.debug("Loading Librarian")

    $(document).on "barcode_nebis", (e) => @on_nebis(e.message)
    $(document).on "barcode_item", (e) => @on_item(e.message)

  on_nebis: (nebis) ->
    console.debug("catched barcode_nebis: %s", nebis)
    if @nebis && @nebis == nebis
      inactivity_monitor.reset()
    else
      location.href = "/nebis/"+nebis

  on_item: (inv) ->
    id = parseInt(inv)
    console.debug("catched barcode_book: %s   id=%s", inv, id)
    if @nebis
      return_link = jQuery('a[data-item-id='+id+']')
      if return_link.size()==0
        console.debug("the book is not in the list. Checking out")
        jQuery('#loan_item_id').val(inv)
        jQuery('#new_loan .btn').click()
      else
        console.debug("the book is already in the list. Returning it")
        return_link[0].click()
    else
      thot.alert("info", "Please scan your nebis code before scanning any book label")
