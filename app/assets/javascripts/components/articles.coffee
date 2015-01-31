jQuery ($) ->

  delay = ( callback, milliseconds ) -> setTimeout( callback, milliseconds )

  timeout = null

  $( '.js-search-form' ).on 'input', ->
    guides   = $( '.js-guides' )
    articles = $( '.js-article-list' )

    if $( 'body' ).hasClass( 'guides-index' )
      if $( '.js-search-input' ).val() == ''
        guides.removeClass( 'dn' )
        articles.addClass( 'dn' )
      else
        guides.addClass( 'dn' )
        articles.removeClass( 'dn' )

    clearTimeout( timeout ) if timeout

    timeout = delay ->
      $( '.js-search-form' ).submit()
    , 200
