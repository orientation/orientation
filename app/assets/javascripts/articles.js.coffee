# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    console.log "submitted that damned form"
    $('.search-bar form').submit()

  timeout = null

  $('#search').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()

  $('textarea#article_content').on 'keydown', (evt)->
    if evt.keyCode == 9
      keycode = evt.keycode
      evt.preventDefault()
      $('textarea#article_content').insertAtCaret('  ')