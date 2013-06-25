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
          console.debug("this was a camipro card number: %s", @inputString);
          $.event.trigger( { type: "barcode_nebis", message: @inputString } )
          @inputString = ""
        else if ( @inputString.charAt(0)=="S" && @inputString.length > 3 )
          console.debug("this should be a shelf: %s", @inputString)
          $.event.trigger( { type: "barcode_shelf", message: @inputString } )
          @inputString = ""
        else if @inputString.match(/^[0-9][0-9][0-9][0-9][0-9]*$/)
          console.debug("this should be a book id: %s", @inputString)
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

class window.BarcodeScanner2
  constructor: (d) ->

    console.debug("loading barcode scanner2: d="+d+" ms")

    @nebis = false
    @scannerKeypressMaxDelay = d;
    @baseUrl = "/"

    @scannerActive = true
    @lastKeypressTime = jQuery.now()
    @inputString = ""

    jQuery('body').keypress( (e) => @onKeypress(e) )

  setNebis: (n) -> @nebis = n

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
        if (@inputString.length==8 && @inputString.charAt(0)=="E")
          nebis=@inputString
          console.debug("this was a camipro card number: %s   -   @nebis = %s", nebis, @nebis);
          if (nebis != @nebis)
            url=@baseUrl + "nebis/" + nebis
            # TODO: remove this line when done debugging !!!!
            # url=@baseUrl + "nebis/" + "E0593158"
            console.debug("Should redirect to " + url)
            location.href = url
        else if @inputString.match(/^[0-9][0-9][0-9][0-9][0-9]*$/)
          console.debug("this should be a book id: %s", @inputString)
          if @nebis
            return_link = jQuery('a[data-inv='+@inputString+']')
            console.debug("return_link = " + return_link)
            if return_link.size()==0
              console.debug("the book is not in the list. Checking out")
              jQuery('#loan_inv').val(@inputString)
              jQuery('#new_loan .btn').click()
            else
              console.debug("the book is already in the list. Returning it")
              return_link[0].click()
          else
            @inputString = ""
            thot.alert("info", "Please scan your nebis code before scanning any book label")
            console.debug("not in user/nebis page -> discarding")

      else if (kcode>47 && kcode<58 || kcode>64 && kcode<91 || kcode>96 && kcode<123)
        if now - @lastKeypressTime < @scannerKeypressMaxDelay
          @inputString += kchar
          # Event.stop(e)
        else
          @inputString = ""
    # console.debug("keypress: k= %s   char= %s    inputString= %s", kcode, kchar, @inputString)
    @lastKeypressTime = now
