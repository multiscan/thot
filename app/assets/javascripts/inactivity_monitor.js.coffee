class window.InactivityMonitor
  # needs:
  constructor: (it) ->
    @inactivityTimeout = it*1000;
    # @inactivityTimeout = 10000;
    @reset_url = gon.nebis_extend_url
    console.debug("Loading InactivityMonitor  timeout="+@inactivityTimeout)

    unless gon.root
      console.debug("Activating InactivityMonitor")
      @timeoutLabel = jQuery('#grace_timeout')
      @timeoutDialog = jQuery('#grace_timeout_dialog')

      jQuery('#grace_timeout_dialog a.reset_timer_link').click(=> @reset())
      jQuery('body').mousemove( => @touch() )
      @touch()
      @resetDeadline()

  touch: () ->
    @lastActivityTime = jQuery.now()

  nextActivityDeadline: () ->
    @lastActivityTime + @inactivityTimeout

  resetDeadline: () ->
    clearInterval(@activityDeadline) if @activityDeadline?
    @activityDeadline = setTimeout ( =>
        @onInactivityDeadlineReached()
      ), @nextActivityDeadline() - jQuery.now()

  onInactivityDeadlineReached: () ->
    now = jQuery.now()
    if now < @nextActivityDeadline()
      @resetDeadline
    else
      @showAlert()

  showAlert: () ->
    # if an alert dialog is present then show it and start a countdown otherwise redirect imediately
    if (typeof @timeoutDialog == 'undefined' || @timeoutDialog.length == 0)
      @redirect()
    else
      @graceSeconds=10
      @timeoutLabel.text(@graceSeconds)
      @timeoutDialog.modal('show');
      @tickInterval = setInterval ( =>
          @tick()
        ), 1000

  hideAlert: () ->
    clearInterval(@tickInterval) if @tickInterval?
    @timeoutDialog.modal('hide');

  tick: () ->
    @graceSeconds = @graceSeconds - 1
    if @graceSeconds >=0
      @timeoutLabel.text(@graceSeconds)
    else
      @redirect()

  redirect: () ->
    console.debug("should redirect")
    location.href = "/"

  reset: () ->
    @hideAlert()
    @touch()
    @resetDeadline()

    # TODO: move this stuff into Librarian
    if @reset_url
      jQuery.ajax @reset_url,
                  type: 'GET', dataType: 'json',
                  error: (jqXHR, textStatus, errorThrown) ->
                    thot.alert("error", "Could not renew your session. You will have to scan your Nebis code again")
                  success: (data, textStatus, jqXHR) ->
                    thot.alert("success", "Your nebis session have been renewed.")

