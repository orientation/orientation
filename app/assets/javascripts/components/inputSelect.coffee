# *************************************
#
#   Input Select
#   -> Select text on focus
#
# *************************************
#
# @param element { jQuery object }
#
# *************************************

@Orientation.inputSelect = ( options ) ->
  settings = $.extend
    element : $( '.js-inputSelect' )
  , options

  settings.element.on 'focus', ->
    $(@).trigger( 'select' )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.inputSelect()
#
