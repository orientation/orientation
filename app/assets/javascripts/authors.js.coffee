$(document).on "page:change", ->
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

  $('.authors-index .authors').masonry
    itemSelector: '.author',
    columnWidth: (containerWidth) ->
      containerWidth / 3
