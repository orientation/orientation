# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  domready = ->

    Orientation.accordion()
    Orientation.autoSubmit()
    Orientation.dropdown()
    Orientation.inputSelect()

    Orientation.tableBank
      context : $('.markdown')
      element : $('table')
      gutter  : '20'

    # -------------------------------------
    #   Fullscreen Editor
    # -------------------------------------

    $.fn.redraw = ->
      $(@).each ->
        redraw = this.offsetHeight

    $( '.js-editor-open' ).on 'click', ( event ) ->
      event.preventDefault()

      $( '.js-editor-textarea' )
        .addClass( 'is-editing' )
        .parent( '.js-editor-overlay' )
        .addClass( 'is-active' )

      setTimeout $('.js-editor-textarea').focus(), 50

    $(document).on 'click', '.js-editor-close', ( event ) ->
      event.preventDefault()

      $( '.js-editor-overlay' ).removeClass( 'is-active' )
      $( '.js-editor-textarea' ).removeClass( 'is-editing' ).focus()

  # -------------------------------------
  #   Turbolinks & DOM Ready Handlers
  # -------------------------------------

  $( document ).ready( domready )
  $( document ).on( 'page:load', domready )
