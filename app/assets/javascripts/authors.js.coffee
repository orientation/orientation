initialize = (method) ->
  if @initialized == true && !@method == "jquery"
    console.log "already initialized authors"
    return false

  @initialized = true
  @method = method
  console.log "proceeding with initialization via #{method}"
  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    console.log "submitted that damned form"
    $('.search-bar form').submit()

  attach_loading_indicators = ->
    $(document).on 'page:fetch', -> NProgress.start()
    $(document).on 'page:load', -> NProgress.done()

  timeout = null

  attach_loading_indicators()

  $('#search').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()

initialize_via_turbolinks = ->
  console.log "attempting to initialize via turbolinks"
  $(window).on "page:change", ->
    initialize("turbolinks")

initialize_via_jquery = ->
  console.log "attempting to initialize via jQuery"
  $ ->
    initialize("jquery")

initialize_via_turbolinks()
initialize_via_jquery()
