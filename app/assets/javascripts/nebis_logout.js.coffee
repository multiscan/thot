# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class window.NebisLogout
  constructor: (t) ->
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
      thot.alert("error", resp.alert);

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
