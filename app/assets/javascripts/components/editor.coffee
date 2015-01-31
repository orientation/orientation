# *************************************
#
#   Editor
#   -> Expandable textarea
#
# *************************************
#
# @param element         { jQuery object }
# @param openElement     { jQuery object }
# @param closeElement    { jQuery object }
# @param overlayElement  { jQuery object }
# @param textareaElement { jQuery object }
# @param closeQuery      { string }
# @param activeClass     { string }
# @param editingClass    { string }
#
# *************************************

@Orientation.editor = ( options ) ->
  settings = $.extend
    element         : $( '.js-editor' )
    openElement     : $( '.js-editor-open' )
    closeElement    : $( '.js-editor-close' )
    overlayElement  : $( '.js-editor-overlay' )
    textareaElement : $( '.js-editor-textarea' )
    closeQuery      : '.js-editor-close'
    activeClass     : 'is-active'
    editingClass    : 'is-editing'
  , options

  $.fn.redraw = ->
    $(@).each ->
      redraw = this.offsetHeight

  settings.openElement.on 'click', ( event ) ->
    event.preventDefault()

    settings.textareaElement
      .addClass( settings.editingClass )
      .parent( settings.overlayElement )
      .addClass( settings.activeClass )

    settings.textareaElement.trigger( 'focus' )

  $( document ).on 'click', settings.closeQuery, ( event ) ->
    event.preventDefault()

    settings.overlayElement.removeClass( settings.activeClass )
    settings.textareaElement.removeClass( settings.editingClass ).trigger( 'focus' )

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.editor()
#
