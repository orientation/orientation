# *************************************
#
#   Search
#   -> Asynchronous search results
#
# *************************************
#
# @param element        { jQuery object }
# @param formElement    { jQuery object }
# @param inputElement   { jQuery object }
# @param resultsElement { jQuery object }
# @param inputDelay     { integer }
# @param callback       { function }
#
# *************************************

@Orientation.search = ( options ) ->
  settings = $.extend
    element        : $( '.js-search' )
    formElement    : $( '.js-search-form' )
    inputElement   : $( '.js-search-input' )
    resultsElement : $( '.js-search-results' )
    inputDelay     : 200
    callback       : null
  , options

  timeout = null
  delay   = ( callback, milliseconds ) ->
    setTimeout( callback, milliseconds )

  settings.inputElement.on 'input', ->
    clearTimeout( timeout ) if timeout

    timeout = delay =>
      $(@).closest( settings.element ).find( settings.formElement ).trigger( 'submit' )
      settings.callback( settings ) if settings.callback?
    , settings.inputDelay

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.search()
#
