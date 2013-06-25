class window.BarcodeScanner
  constructor: (d) ->

    console.debug("loading barcode scanner: d="+d+" ms")

    @scannerKeypressMaxDelay = d;

    @scannerActive = true
    @lastKeypressTime = jQuery.now()
    @inputString = ""

    jQuery('body').keypress( (e) => @onKeypress(e) )

  onKeypress: (e) ->
    now = jQuery.now()
    kcode = e.keyCode
    kchar = String.fromCharCode(kcode)
    #     ESC activate/deactivate barcode scanner
    if kcode==27
      @scannerActive=!@scannerActive;
      console.debug("scanner is now: %s", scannerActive ? "active" : "inactive");
    else
      return unless @scannerActive
      if kcode == 13
        if ( @inputString.charAt(0)=="E" && @inputString.length==8)
          $.event.trigger( { type: "barcode_nebis", message: @inputString } )
          @inputString = ""
        else if ( @inputString.charAt(0)=="S" && @inputString.length > 3 )
          $.event.trigger( { type: "barcode_shelf", message: @inputString } )
          @inputString = ""
        else if ( @inputString.charAt(0)=="I" && @inputString.length > 3 )
          $.event.trigger( { type: "barcode_item", message: @inputString } )
          @inputString = ""
        else if @inputString.match(/^[0-9][0-9][0-9][0-9][0-9]*$/)
          $.event.trigger( { type: "barcode_item", message: @inputString } )
          @inputString = ""
      else if (kcode>47 && kcode<58 || kcode>64 && kcode<91 || kcode>96 && kcode<123)
        if now - @lastKeypressTime < @scannerKeypressMaxDelay
          @inputString += kchar
        else
          @inputString = ""
    @lastKeypressTime = now

  simulate_shelf: (sid) -> $.event.trigger( { type: "barcode_shelf", message: sid } )
  simulate_item:  (inv) -> $.event.trigger( { type: "barcode_item",  message: inv } )
  simulate_nebis: (nn)  -> $.event.trigger( { type: "barcode_nebis", message: nn  } )
