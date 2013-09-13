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
    kcode = e.charCode
    kcode = e.keyCode if kcode == 0
    kchar = String.fromCharCode(kcode)
    # console.debug("@ " + now + " - key:" + kcode + "  -  " + kchar)
    # console.debug(e)
    #     ESC activate/deactivate barcode scanner
    if kcode==27
      @scannerActive=!@scannerActive;
      console.debug("scanner is now: %s", scannerActive ? "active" : "inactive");
    else
      return unless @scannerActive
      if kcode == 13 || kcode == 0
        if ( @inputString.charAt(0)=="E" && @inputString.length==8)
          # console.debug("Nebis Barcode")
          $.event.trigger( { type: "barcode_nebis", message: @inputString } )
          @inputString = ""
        else if ( @inputString.charAt(0)=="S" && @inputString.length > 3 )
          # console.debug("Shelf Barcode")
          $.event.trigger( { type: "barcode_shelf", message: @inputString } )
          @inputString = ""
        else if ( @inputString.charAt(0)=="I" && @inputString.length > 3 )
          # console.debug("Nebis Barcode")
          $.event.trigger( { type: "barcode_item", message: @inputString } )
          @inputString = ""
        else if @inputString.match(/^[0-9][0-9]*$/)
          # console.debug("Item Barcode")
          $.event.trigger( { type: "barcode_item", message: @inputString } )
          @inputString = ""
      else if kcode == 83
        @inputString = "S"
      else if kcode == 69
        @inputString = "E"
      else if (kcode>47 && kcode<58)
        if now - @lastKeypressTime < @scannerKeypressMaxDelay
          @inputString += kchar
        else
          @inputString = kchar
    @lastKeypressTime = now

  simulate_shelf: (sid) -> $.event.trigger( { type: "barcode_shelf", message: sid } )
  simulate_item:  (inv) -> $.event.trigger( { type: "barcode_item",  message: inv } )
  simulate_nebis: (nn)  -> $.event.trigger( { type: "barcode_nebis", message: nn  } )
