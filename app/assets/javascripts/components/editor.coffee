# *************************************
#
#   Editor
#   -> Expandable textarea
#
# *************************************
#
# @param $element     { jQuery object }
# @param $open        { jQuery object }
# @param $close       { jQuery object }
# @param $overlay     { jQuery object }
# @param $textarea    { jQuery object }
# @param closeQuery   { string }
# @param activeClass  { string }
# @param editingClass { string }
#
# *************************************

@Orientation.editor = ( options ) ->
  settings = $.extend
    $element     : $( '.js-editor' )
    $open        : $( '.js-editor-open' )
    $close       : $( '.js-editor-close' )
    $overlay     : $( '.js-editor-overlay' )
    $textarea    : $( '.js-editor-textarea' )
    closeQuery   : '.js-editor-close'
    activeClass  : 'is-active'
    editingClass : 'is-editing'
  , options

  $.fn.redraw = ->
    $(@).each ->
      redraw = this.offsetHeight

  settings.$open.on 'click', ( event ) ->
    event.preventDefault()

    settings.$textarea
      .addClass( settings.editingClass )
      .parent( settings.$overlay )
      .addClass( settings.activeClass )

    settings.$textarea.trigger( 'focus' )

  $( document ).on 'click', settings.closeQuery, ( event ) ->
    event.preventDefault()

    settings.$overlay.removeClass( settings.activeClass )
    settings.$textarea.removeClass( settings.editingClass ).trigger( 'focus' )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.editor()
#
