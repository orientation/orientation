# *************************************
#
#   Accordion
#   -> Collapsible container
#
# *************************************
#
# @param $element { jQuery object }
# @param $button  { jQuery object }
# @param $content { jQuery object }
#
# *************************************

@Orientation.accordion = ( options ) ->
  settings = $.extend
    $element : $( '.js-accordion' )
    $button  : $( '.js-accordion-button' )
    $content : $( '.js-accordion-content' )
  , options

  settings.$content.hide()

  settings.$button.on 'click', ( event ) ->
    $(@).closest( settings.$element ).find( settings.$content ).slideToggle()

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.accordion()
#
