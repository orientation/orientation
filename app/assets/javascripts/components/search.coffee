# *************************************
#
#   Search
#   -> Asynchronous search results
#
# *************************************
#
# @param $element    { jQuery object }
# @param $alternate  { jQuery object }
# @param $form       { jQuery object }
# @param $input      { jQuery object }
# @param $results    { jQuery object }
# @param hiddenClass { string }
# @param inputDelay  { integer }
# @param onSubmit    { function }
#
# *************************************

@Orientation.search = ( options ) ->
  settings = $.extend
    $element    : $( '.js-search' )
    $alternate  : $( '.js-search-alternate' )
    $form       : $( '.js-search-form' )
    $input      : $( '.js-search-input' )
    $results    : $( '.js-search-results' )
    hiddenClass : 'is-hidden'
    inputDelay  : 400
    onSubmit    : null
  , options

  timeout = null

  delay = ( callback, milliseconds ) ->
    setTimeout( callback, milliseconds )

  hideSearch = ->
    settings.$results.hasClass( 'hide-results' )

  settings.$input.on 'input', ->
    clearTimeout( timeout ) if timeout

    queryLength = settings.$input.val().length

    return if queryLength > 0 && queryLength < 3

    timeout = delay =>
      $(@).closest( settings.$element ).find( settings.$form ).trigger( 'submit' )
      settings.onSubmit( settings ) if settings.onSubmit?

      if settings.$input.val()
        settings.$alternate.addClass( settings.hiddenClass )
        settings.$results.removeClass( settings.hiddenClass )
      else
        settings.$alternate.removeClass( settings.hiddenClass )
        settings.$results.addClass( settings.hiddenClass ) if hideSearch()

    , settings.inputDelay

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.search()
#
