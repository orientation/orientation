# *************************************
#
#   Dropdown
#   -> Contextual menu
#
# *************************************
#
# @param elementClass { string }
# @param buttonClass  { string }
# @param activeClass  { string }
#
# *************************************

@Orientation.dropdown = ( options ) ->
  settings = $.extend
    elementClass : 'js-dropdown'
    buttonClass  : 'js-dropdown-button'
    activeClass  : 'is-active'
  , options

  $( document ).on 'click', ".#{ settings.buttonClass }", ( event ) ->
    event.preventDefault()
    event.stopPropagation()

    $(@).closest( ".#{ settings.elementClass }" ).toggleClass( settings.activeClass )

  $( document ).on 'click', ->
    $( ".#{ settings.elementClass }" ).removeClass( settings.activeClass )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.dropdown()
#
