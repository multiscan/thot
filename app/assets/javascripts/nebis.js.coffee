# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class window.NebisLogout
  constructor: (t) ->
    console.debug("4")
    @dt = t * 1000
    @timeoutLabel = jQuery('#nebis_timeout')
    @timeoutDialog = jQuery('#nebis_timeout_dialog')
    @tickInterval = 0
    @resetCountdown()

    jQuery('#reset_timer_link').bind 'ajax:success', (evt, data) =>
      @resetCountdown()
      @timeoutDialog.modal 'hide'

    jQuery('#reset_timer_link').bind 'ajax:error', (evt, data) =>
      resp=JSON.parse(data.responseText)
      @timeoutDialog.modal('hide');
      add_alert("error", resp.alert);

  timeLeft: () -> @t0 - jQuery.now()

  secondsToGo: () -> Math.round @timeLeft()/1000

  tick: () ->
    if @secondsToGo() >=0
      @timeoutLabel.text(@secondsToGo())
    else
      clearInterval(@tickInterval)
      @timeoutDialog.modal('hide');

  resetCountdown: () ->
    @t0 = jQuery.now() + @dt
    setTimeout ( =>
        @showAlert()
      ), @timeLeft() - 5000

  showAlert: () ->
    @timeoutLabel.text(@secondsToGo())
    @tickInterval = setInterval ( =>
        @tick()
      ), 1000
      @timeoutDialog.modal('show');




class window.BarcodeScanner
  constructor: (it, ru) ->

    @inactivityTimeout = it
    @inactivityRedirectUrl = ru

    @scannerActive = true
    @lastKeypressTime = jQuery.now()

    jQuery('body').mousemove( => @touch() )

    @touch()
    @setDeadline()

  touch: () ->
    @lastActivityTime = jQuery.now()
    @nextActivityDeadline = @lastActivityTime + @inactivityTimeout
    console.log("touch next="+@nextActivityDeadline)

  setDeadline: () ->
    clearInterval(@nextDeadline) if @nextDeadline?
    now = jQuery.now()

  onInactivityDeadlineReached: () ->
    now = jQuery.now()
    if now < @nextActivityDeadline
      @setDeadline
    else
      console.log("should redirect")
      // location.href = @inactivityRedirectUrl



# document.observe("dom:loaded", function() {
#   document.observe('mousemove', function(event){
#     lastActivityTime = new Date();
#   });
#   document.observe('keydown', function(event){
#     var thisKepressTime=new Date();
#     lastActivityTime = thisKepressTime;
#     var kcode=event.keyCode;
#     // console.log("KeyDown: code="+kcode);
#     // return;
#     switch(kcode) {
#       case 27: // ESC
#         scannerActive=!scannerActive;
#         //console.log("scanner is now: %s", scannerActive ? "active" : "inactive");
#       // case Event.KEY_RETURN:
#       // case Event.KEY_BACKSPACE: //8
#       // case Event.KEY_DELETE: //46
#       break;
#     }
#     if (scannerActive) {
#       if (kcode==13){
#          //console.log("current url=%s", location.href);
#          //console.log("current search=%s", location.search);
#         var search= location.search=="" ? "?" : location.search;
#         if (inputString.length==8 && inputString.charAt(0)=="E") {
#            // console.log("this was a camipro card number: %s", inputString);
#           getVars.set('userId', inputString);
#           getVars.unset('invNumber');
#           var newurl="http://thot.epfl.ch/checkout.php?"+getVars.toQueryString();
#           //alert("redirecting to "+newurl);
#           location.href=newurl;
#         } else {
#           // add condition checking if userId is set
#           var n=Number(inputString);
#           // console.debug("this should be a book code: %d", n);
#           getVars.set('invNumber', n);
#           if (getVars.get('userId') && inputString.length>=4 && inputString.match(/^[0-9][0-9][0-9][0-9][0-9]*$/)) {
#             var newurl="http://thot.epfl.ch/checkout.php?"+getVars.toQueryString();
#             //alert("redirecting to "+newurl);
#             location.href=newurl;
#           } else {
#             var newurl="http://thot.epfl.ch/index.php?go=Detail&"+getVars.toQueryString();
#       location.href=newurl;
#           }
#         }
#       }
#       var elapsedSinceLastKeyPress = thisKepressTime - lastKeypressTime;
#       // if more than 20ms since last key press we reset the buffer because it cannot come from scanner
#       if (elapsedSinceLastKeyPress > 100) {
#         inputString="";
#       }
#       if (kcode>47 && kcode<58 || kcode>64 && kcode<91 || kcode>96 && kcode<123) {
#         inputString += String.fromCharCode(kcode);
#       }
#     } else {
#       if (kcode==13) {
#         Event.stop(event);
#         return false;
#       }
#     }
#     //console.log("%s: Premuto tasto %s. string='%s'   %d", elapsedSinceLastKeyPress, kcode, inputString, inputString.length);
#     lastKeypressTime = thisKepressTime;
#   });
#   // parse search string
#   var qString = unescape(location.search.substring(1));
#   var pairs = qString.split(/\&/);
#   pairs.each(function(item) {
#     var nameVal = item.split(/\=/);
#     getVars.set(nameVal[0], nameVal[1]);
#   });
#   if (getVars.get('userId')) {
#     // console.log("userId is given");
#     new PeriodicalExecuter(checkActivityTimeout, 10);
#   }
# });

