jQuery ($) ->

  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    $('.js-search-form').submit()

  timeout = null

  $('.js-search-input').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()
