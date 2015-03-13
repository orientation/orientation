# *************************************
#
#   Heading Link
#   -> Selectable anchor
#
# *************************************
#
# @param $element    { jQuery object }
# @param $heading    { jQuery object }
# @param $link       { jQuery object }
# @param activeClass { string }
#
# *************************************

@Orientation.headingLink = ( options ) ->
  settings = $.extend
    $element    : $( '.js-headingLink' )
    $heading    : $( '.js-headingLink-heading' )
    $link       : $( '.js-headingLink-link' )
    activeClass : 'is-active'
  , options

  settings.$element.each ->
    $link     = $(@).find( settings.$link )
    permalink = window.location.origin + window.location.pathname + $link.val()

    $link.val( permalink )

  settings.$element.on 'click', ( event) ->
    $element = $(@)
    $heading = $element.find( settings.$heading )
    $link    = $element.find( settings.$link )

    event.preventDefault()

    $link.css
      'margin-bottom' : $element.css( 'margin-bottom' )

    $element.addClass( settings.activeClass )
    $link.outerHeight( $heading.outerHeight() )
    $link.trigger( 'focus' ).trigger( 'select' )

    settings.$link.one 'blur', ->
      $element.removeClass( settings.activeClass )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.headingLink()
#
