class window.InactivityMonitor
  constructor: (it) ->

    @inactivityTimeout = it*1000;

    # proto = window.location.protocol
    # host  = window.location.host
    # @baseUrl = proto + "//" + host + "/"
    @baseUrl = "/"
    @inactivityRedirectUrl = @baseUrl

    jQuery('body').mousemove( => @touch() )
    @touch()
    @setDeadline()

  touch: () ->
    @lastActivityTime = jQuery.now()
    @nextActivityDeadline = @lastActivityTime + @inactivityTimeout

  setDeadline: () ->
    clearInterval(@nextDeadline) if @nextDeadline?
    now = jQuery.now()
    @nextDeadline = setTimeout ( =>
        @onInactivityDeadlineReached()
      ), @nextActivityDeadline - now

  onInactivityDeadlineReached: () ->
    now = jQuery.now()
    if now < @nextActivityDeadline
      @setDeadline
    else
      console.log("should redirect")
      # location.href = @inactivityRedirectUrl

