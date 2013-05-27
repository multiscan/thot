class window.BarcodeScanner
  constructor: (d) ->

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
      console.log("scanner is now: %s", scannerActive ? "active" : "inactive");
    else
      return unless @scannerActive
      if kcode == 13
        if (@inputString.length==8 && @inputString.charAt(0)=="E")
          nebis=@inputString
          console.log("this was a camipro card number: %s", nebis);
          if (nebis != @nebis)
            url=@baseUrl + "users/" + nebis
            # TODO: remove this line when done debugging !!!!
            # url=@baseUrl + "users/" + "E0593158"
            console.log("Shoudl redirect to " + url)
            location.href = url
        else if @inputString.match(/^[0-9][0-9][0-9][0-9][0-9]*$/)
          console.log("this should be a book id: %s", @inputString)
          if @nebis
            return_link = jQuery('a[data-inv='+@inputString+']')
            if return_link.size()==0
              console.log("the book is not in the list. Checking out")
              jQuery('#loan_inv').val(@inputString)
              jQuery('#new_loan .btn').click()
            else
              console.log("the book is already in the list. Returning it")
              return_link[0].click()
          else
            @inputString = ""
            thot_alert("notice", "Please scan your nebis code before scanning any book label")
            console.log("not in user/nebis page -> discarding")

      else if (kcode>47 && kcode<58 || kcode>64 && kcode<91 || kcode>96 && kcode<123)
        if now - @lastKeypressTime < @scannerKeypressMaxDelay
          @inputString += kchar
          # Event.stop(e)
        else
          @inputString = ""
    console.log("keypress: k= %s   char= %s    inputString= %s", kcode, kchar, @inputString)
    @lastKeypressTime = now
