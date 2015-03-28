# *************************************
#
#   Search
#   -> Asynchronous search results
#
# *************************************
#
# @param element    { jQuery object }
# @param $form      { jQuery object }
# @param $input     { jQuery object }
# @param $results   { jQuery object }
# @param inputDelay { integer }
# @param callback   { function }
#
# *************************************

@Orientation.search = ( options ) ->
  settings = $.extend
    $element    : $( '.js-search' )
    $form      : $( '.js-search-form' )
    $input     : $( '.js-search-input' )
    $results   : $( '.js-search-results' )
    inputDelay : 200
    callback   : null
  , options

  timeout = null
  delay   = ( callback, milliseconds ) ->
    setTimeout( callback, milliseconds )

  settings.$input.on 'input', ->
    clearTimeout( timeout ) if timeout

    timeout = delay =>
      $(@).closest( settings.element ).find( settings.$form ).trigger( 'submit' )
      settings.callback( settings ) if settings.callback?
    , settings.inputDelay

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.search()
#
