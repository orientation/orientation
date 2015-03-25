# *************************************
#
#   Dropdown
#   -> Responsive table overflow
#
# *************************************
#
# @param $element             { jQuery object }
# @param $context             { jQuery object }
# @param elementClass         { string }
# @param containerClass       { string }
# @param originalClass        { string }
# @param originalMessageClass { string }
# @param originalTableClass   { string }
# @param toggleClass          { string }
# @param activeClass          { string }
# @param gutter               { integer }
#
# *************************************

@Orientation.tableBank = do ->

  # -------------------------------------
  #   Private Variables
  # -------------------------------------

  _settings = {}

  # -------------------------------------
  #   Initialize
  # -------------------------------------

  init = ( options ) ->
    _settings = $.extend
      $element              : $( 'table' )
      $context              : $( '.js-tableBank' )
      elementClass         : 'tableBank'
      containerClass       : 'tableBank-container'
      originalClass        : 'tableBank-original'
      originalMessageClass : 'tableBank-original-message'
      originalTableClass   : 'tableBank-original-table'
      toggleClass          : 'js-tableBank-toggle'
      activeClass          : 'is-active'
      gutter               : 20
    , _settings

    _wrapTables()

  # -------------------------------------
  #   Set Event Handlers
  # -------------------------------------

  _setEventHandlers = ( $context ) ->
    $context.find( ".#{ _settings.toggleClass }" ).on 'click', ( event ) ->
      event.preventDefault()
      $context.closest( ".#{ _settings.elementClass }" ).toggleClass( _settings.activeClass )

  # -------------------------------------
  #   Add Style Sheet
  # -------------------------------------

  _addStyleSheet = ( tableWidth ) ->
    gutter = _settings.gutter * 2

    $( 'head' ).append """
      <style>
        @media screen and ( min-width: #{ tableWidth + ( gutter ) }px ) {
          .#{ _settings.elementClass }--#{ tableWidth } .#{ _settings.originalClass } {
            display: block;
          }
        }

        @media screen and ( max-width: #{ tableWidth + ( gutter ) }px ) {
          .#{ _settings.elementClass }.#{ _settings.elementClass }--#{ tableWidth }.#{ _settings.activeClass } .#{ _settings.originalClass } {
            display: none;
          }
        }
      </style>
    """

  # -------------------------------------
  #   Wrap Tables
  # -------------------------------------

  _wrapTables = ->
    _settings.$context.find( _settings.$element ).each ->

      $element = $(@)
      $originalTable = $element.clone().addClass( _settings.originalTableClass )
      tableWidth = $element.width()

      messageText = """
        This table has been contained to fit, but you can
        <a href='#' class='#{ _settings.toggleClass }'>
          toggle the original.
        </a>
      """

      originalBlock = """
        <div class='#{ _settings.originalClass }'>
          <p class='#{ _settings.originalMessageClass }'>#{ messageText }</p>
        </div>
      """

      $element.wrap( "<div class='#{ _settings.elementClass } #{ _settings.elementClass }--#{ tableWidth }'></div>" )
      $element.before( originalBlock )

      if tableWidth > _settings.$context.innerWidth()
        $tableBank = $element.closest( ".#{ _settings.elementClass }" )
        $original  = $tableBank.find( ".#{ _settings.originalClass }" )
        $original.append( $originalTable )

        $element.wrap( "<div class='#{ _settings.containerClass }'></div>" )

        _addStyleSheet( tableWidth )
        _setEventHandlers( $tableBank )
      else
        $element.wrap "<div class='#{ _settings.containerClass }'></div>"

  # -------------------------------------
  #   Public Methods
  # -------------------------------------

  init: init

# -------------------------------------
#   Usage
# -------------------------------------
#
# Orientation.tableBank.init()
#
