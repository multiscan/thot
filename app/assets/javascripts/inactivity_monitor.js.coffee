class window.InactivityMonitor
  # needs:
  constructor: (it) ->

    unless gon.root
      @inactivityTimeout = it*1000;

      console.debug("loading InactivityMonitor  timeout="+@inactivityTimeout)

      @reset_url = gon.nebis_extend_url

      @timeoutLabel = jQuery('#grace_timeout')
      @timeoutDialog = jQuery('#grace_timeout_dialog')

      jQuery('body').mousemove( => @touch() )
      @touch()
      @resetDeadline()

  touch: () ->
    @lastActivityTime = jQuery.now()

  nextActivityDeadline: () ->
    @lastActivityTime + @inactivityTimeout

  resetDeadline: () ->
    clearInterval(@activityDeadline) if @activityDeadline?
    @actovotuDeadline = setTimeout ( =>
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
      @graceSeconds=5
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
    console.log("should redirect")
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

