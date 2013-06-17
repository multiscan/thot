class window.Inventory
  constructor: () ->
    $(document).on "barcode_shelf", (e) => @on_shelf(e.message)
    $(document).on "barcode_item", (e) => @on_item(e.message)
