# *************************************
#
#   Accordion
#   -> Collapsible container
#
# *************************************
#
# @param element { jQuery object }
#
# *************************************

@Orientation.accordion = ( options ) ->
  settings = $.extend
    element        : $( '.js-accordion' )
    buttonElement  : $( '.js-accordion-btn' )
    contentElement : $( '.js-accordion-content' )
  , options

  settings.contentElement.hide()

  settings.buttonElement.on 'click', ( event ) ->
    console.log 'string'
    $(@).closest( settings.element ).find( settings.contentElement ).slideToggle()

# -------------------------------------
#   Usage
# -------------------------------------
#
# Admin.accordion()
#
