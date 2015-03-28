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

@Orientation.editor = do ->

  # -------------------------------------
  #   Private Variables
  # -------------------------------------

  _settings = {}

  # -------------------------------------
  #   Initialize
  # -------------------------------------

  init = ( options ) ->
    _settings = $.extend
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
        redraw = @offsetHeight

    _setEventHandlers()

  # -------------------------------------
  #   Exit Fullscreen
  # -------------------------------------

  _exitFullscreen = ->
    if _settings.$textarea.hasClass( _settings.editingClass )
      _settings.$overlay.removeClass( _settings.activeClass )
      _settings.$textarea.removeClass( _settings.editingClass )

      setTimeout ->
        _settings.$textarea.trigger( 'focus' )
      , 50

  # -------------------------------------
  #   Set Event Handlers
  # -------------------------------------

  _setEventHandlers = ->
    $( document ).on 'keyup', ( event ) ->
      if event.which == 27 and $( ':focus' ).is( _settings.$textarea )
        event.preventDefault()

        _settings.$textarea.trigger( 'blur' )

    _settings.$open.on 'click', ( event ) ->
      event.preventDefault()

      _settings.$textarea
        .addClass( _settings.editingClass )
        .parent( _settings.$overlay )
        .addClass( _settings.activeClass )

      _settings.$textarea.trigger( 'focus' )

    $( document ).on 'click', _settings.closeQuery, ( event ) ->
      event.preventDefault()

      _exitFullscreen()

    _settings.$textarea.on 'blur', ( event ) ->
      _exitFullscreen()

  # -------------------------------------
  #   Public Methods
  # -------------------------------------

  init : init

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.init()
#
