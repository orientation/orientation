jQuery ($) ->

  delay = ( callback, milliseconds ) -> setTimeout( callback, milliseconds )

  timeout = null

  $( '.js-search-input' ).on 'input', ->
    clearTimeout( timeout ) if timeout

    timeout = delay ->
      $('.js-search-form').submit()
    , 400
