# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on "page:change", ->
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
    prePopulate: $('#article_tag_tokens').data('load')
    preventDuplicates: true

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
