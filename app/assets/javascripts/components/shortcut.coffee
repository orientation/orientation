# *************************************
#
#   Shortcut
#   -> Trigger clicking an element after keyup
#
# *************************************
#
#   Dependencies
#   - Orientation.keyCodes
#
# *************************************
#
# @param $element      { jQuery object }
# @param dataAttribute { string }
# @param keyCodes      { object }
#
# *************************************

@Orientation.shortcut = ( options ) ->
  settings = $.extend
    $element      : $( '[data-shortcut]' )
    dataAttribute : 'shortcut'
    keyCodes      : Orientation.keyCodes
  , options

  settings.$element.each ->
    element     = $(@)
    key         = String( element.data( settings.dataAttribute ) )
    keyCode     = settings.keyCodes[ key.toLowerCase() ]
    isInteger   = not isNaN( parseInt( key, 10 ) )
    isUpperCase = key is key.toUpperCase()

    $( document ).on 'keyup', ( event ) =>
      element = $(@)
      tag     = event.target.tagName.toLowerCase()

      unless tag is 'input' or tag is 'textarea'
        if event.which is keyCode

          if ( isUpperCase and event.shiftKey )\
          or ( not isUpperCase and not event.shiftKey )\
          or isInteger
            element.trigger( 'focus' ).trigger( 'click' )

            if element.prop( 'tagName' ).toLowerCase() is 'a'
              window.location = element.attr( 'href' )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.shortcut()
#
