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
    key = settings.keyCodes[ $(@).data( settings.dataAttribute ) ]

    $( document ).on 'keyup', ( event ) =>
      $element = $(@)
      tag      = event.target.tagName.toLowerCase()

      unless tag is 'input' or tag is 'textarea'
        if event.which is key
          $element.trigger( 'focus' ).trigger( 'click' )

          if $element.prop( 'tagName' ).toLowerCase() is 'a'
            window.location = $element.attr( 'href' )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.shortcut()
#
