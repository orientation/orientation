$(document).on 'page:change', ->
  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    $('.js-search-form').submit()

  attach_loading_indicators = ->
    $(document).on 'page:fetch', -> NProgress.start()
    $(document).on 'page:load', -> NProgress.done()

  timeout = null

  attach_loading_indicators()

  $('.js-search-input').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()
