class Thot
  constructor: () ->
    console.debug("Loadin Thot")
    @BARCODE_KEYPRESS_MAXDELAY = 600        # milliseconds
    @INACTIVITY_TIME_BEFORE_RESET = 300     # seconds

  ready: () ->
    console.debug("thot.ready")

    jQuery("table.sortable").tablesorter()
    jQuery("input.typeahead").each () ->
      collection = jQuery(this).data("collection")
      jQuery(this).typeahead({source: collection})
    jQuery("input.date_picker").datepicker()

    jQuery("a.on_loan_popover").popover().click (e) -> e.preventDefault()

    merger = new BookMerger()

    when_ready_for_layout() if (typeof when_ready_for_layout == 'function')
    when_ready_for_view()   if (typeof when_ready_for_view   == 'function')

    if gon.inventory
      console.debug("thot setup for inventory")
      window.barcode_scanner = new BarcodeScanner(@BARCODE_KEYPRESS_MAXDELAY)
      window.inventory = new Inventory()

    unless gon.admin
      console.debug("thot setup for library user")
      window.inactivity_monitor = new InactivityMonitor(@INACTIVITY_TIME_BEFORE_RESET)
      window.barcode_scanner = new BarcodeScanner(@BARCODE_KEYPRESS_MAXDELAY)
      window.librarian = new Librarian()

  # ---------------------------------------------------------- Utility functions

  increase_counter: (id) ->
    c=jQuery(id);
    c.text(parseInt(c.text())+1)

  fade_and_remove: (id) ->
    jQuery(id).fadeOut('slow') ->
      jQuery(this).remove()

  alert: (cls, content) ->
    msg = jQuery('<div class="alert alert-'+cls+'"><a class="close" data-dismiss="alert">×</a><div>'+content+'</div></div>')
    alc = jQuery('#alerts .container')
    switch cls
      when "error"
        msg.prependTo(alc).delay(20000).fadeOut 500, -> $(this).remove()
      when "success", "info"
        msg.prependTo(alc).delay(10000).fadeOut 500, -> $(this).remove()
      else
        msg.prependTo(alc).delay(5000).fadeOut 500, -> $(this).remove()

  scrollTo: (e) ->
    b = jQuery('body')
    H = jQuery(window).height()
    h = e.height()
    y = e.offset().top
    s = b.scrollTop()
    # unless the element is completely visible, scroll element to center window
    unless (y > s && (y+h) < s+H)
      b.scrollTop(y - (H-h)/2)

  selectable_merger: () ->
    $("#selectedselector").hide()
    $("#selectedselector").change ->
      $("#publisher_name").val($(this).val())
    $("#selectable").selectable
      stop: () ->
        choices=[]
        $(".ui-widget-content input").prop('checked', false)
        $(".ui-selected input").prop('checked', true)
        options=$("#selectedselector")
        $("#publisher_name").val("")
        options.empty()
        $(".ui-selected label").each (index)->
          v=$(this).text().trim()
          options.append($("<option></option>").attr("value", v).text(v))
        options.show()

window.thot = new Thot
