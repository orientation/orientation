@initialized = false

initialize = (method) ->
  if @initialized == true && !@method == "jquery"
    console.log "already initialized"
    return false

  @initialized = true
  @method = method
  console.log "proceeding with initialization via #{method}"
  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    console.log "submitted that damned form"
    $('.search-bar form').submit()

  timeout = null

  $('#search').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()

  $('html').on 'keydown','#article_content', (evt)->
    if evt.keyCode == 9
      evt.preventDefault()
      $('textarea#article_content').insertAtCaret('  ')
      evt.preventDefault()

  $('#article_tag_tokens').tokenInput '/tags.json'
    theme: "facebook"
    prePopulate: $('#article_tag_tokens').data('load')

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