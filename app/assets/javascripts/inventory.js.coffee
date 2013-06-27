class window.Inventory
  constructor: () ->
    console.debug("loading Inventory")
    @shelf = gon.shelf
    @inventory = gon.inventory
    @base_shelf_url="/adm/inventory_sessions/"+@inventory+"/shelves/"
    @check_url="/adm/inventory_sessions/"+@inventory+"/check.json"

    $(document).on "barcode_shelf", (e) => @on_shelf(e.message)
    $(document).on "barcode_item", (e) => @on_item(e.message)

  on_shelf: (s) ->
    console.debug("on_shelf s="+s)
    id = parseInt(s.replace(/^[^0-9]*/,''))
    console.debug("on_shelf id="+id)
    unless id == @shelf
      console.debug("should redirect to shelf ",  id)
      location.href = @base_shelf_url + id

  on_item: (id) ->
    console.debug "catched book item scan id=" + id
    if @shelf
      @check(id)
    else
      thot.alert("info", "Please scan a shelf barcode first.")

  check: (id) ->
    jQuery.ajax @check_url,
      type: 'POST',
      dataType: 'json',
      data: {inv: id, shelf: @shelf}
      error: (jqXHR, textStatus, errorThrown) ->
        if (errorThrown=="Not Found")
          thot.alert("error", "The item you have scanned is not among the goods of this inventory session")
      success: (data, textStatus, jqXHR) ->
        id = data.id
        parent_id = data.status
        @new_parent = jQuery("#"+parent_id)
        @old_li = jQuery("#"+id)
        if @old_li.size() == 0
          # console.debug("li with id "+id+" is NOT present and should be inserted into container " + parent_id)
          li = jQuery(data.li)
          li.prependTo(@new_parent).fadeOut(0).fadeIn(500)
        else
          old_parent_id = @old_li.parent().attr("id")
          # console.debug("li with id "+id+" is already present in " + old_parent_id + " container")
          if old_parent_id == parent_id
            # console.debug("li was already in the good container")
            @old_li.effect("highlight", {}, 500)
          else
            # console.debug("li should move from " + old_parent_id + " to " + parent_id + " container")
            @old_li.fadeOut 500, =>
              li=@old_li.detach()
              li.prependTo(@new_parent).fadeOut(0).fadeIn(500)
            # new_parent.prepend(li)
        if data.message
          thot.alert("success", data.message)

