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

  attach_loading_indicators = ->
    $(document).on 'page:fetch', -> NProgress.start()
    $(document).on 'page:load', -> NProgress.done()

  timeout = null

  attach_loading_indicators()

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
  for date in date_inputs
    date = $(date)
    default_date = $.datepicker.parseDate("yy-mm-dd", date.val())
    date.datepicker({ defaultDate: default_date, dateFormat: 'M dd yy' })
    old_time = date.val()
    new_time = moment(old_time).format('MMM Do YYYY')
    date.val(new_time)

  $(document).on "keyup", keyboardEventHandler

keyboardEventHandler = (event) ->
  if event.keyCode == 70 or event.keyCode == 83
    focusSearch()

  if event.keyCode == 27
    unfocusSearch()

focusSearch = ->
  $("#search").trigger "focus"

unfocusSearch = ->
  $("#search").trigger "blur"

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