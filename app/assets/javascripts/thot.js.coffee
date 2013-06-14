class Thot
  constructor: () ->
    #

  ready: () ->
    # load TableSorter on .sortable tables
    jQuery("table.sortable").tablesorter();
    # load typeahead auto-complete list to
    jQuery("input.typeahead").each () ->
      collection = jQuery(this).data("collection")
      jQuery(this).typeahead({source: collection})
    jQuery("input.date_picker").datepicker();

    when_ready_for_layout() if (typeof when_ready_for_layout == 'function')
    when_ready_for_view() if (typeof when_ready_for_view == 'function')

  load_inactivity_monitor: (d) ->
    window.inactivity_monitor = new InactivityMonitor(d);

  load_barcode_scanner: (d) ->
    window.barcode_scanner = new BarcodeScanner(d);

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


window.thot = new Thot
