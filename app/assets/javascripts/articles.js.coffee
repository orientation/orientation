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

  localize_datetimes = ->
    dates = $(".articles time")
    for date in dates
      old_time = $(date).attr('datetime')
      new_time = moment(old_time).format('MMM Do YYYY')
      $(date).html(new_time)

  timeout = null

  $('#search').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()

  $('html').on 'keydown','#article_content', (evt)->
    if evt.keyCode == 9
      $('textarea#article_content').insertAtCaret('  ')
      evt.preventDefault()

  $('#article_tag_tokens').tokenInput '/tags.json',
    theme: "facebook"
    prePopulate: $('#article_tag_tokens').data('load')

  localize_datetimes()

  date_inputs = $("#article_created_at, #article_updated_at")
  date_inputs?.datepicker({ dateFormat: 'M dd yy' })
  for date in date_inputs
    old_time = $(date).val()
    new_time = moment(old_time).format('MMM Do YYYY')
    $(date).val(new_time)


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