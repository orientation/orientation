# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  domready = ->

    #---------------------------------
    #
    #  Dropdown
    #  -> Contextual menus
    #
    #---------------------------------

    $('.js-dropdown-btn').on 'click', ( event ) ->
      event.stopPropagation()
      $(@).closest( '.js-dropdown' ).toggleClass( 'is-active' )

    # TODO: Modularize clickout behavior
    $( document ).on 'click', ->
      $( '.js-dropdown' ).removeClass( 'is-active' )

    #---------------------------------
    #
    #  Accordion
    #  -> Collapsable container
    #
    #---------------------------------

    # Collapse accordion content on DOM Ready
    $( '.js-accordion-content' ).hide()

    $( '.js-accordion-btn' ).on 'click', ( event ) ->
      $(@).closest( '.js-accordion' ).find( '.js-accordion-content' ).slideToggle()

    # -------------------------------------
    #
    #   Auto Submit
    #
    # -------------------------------------

    $( '.js-autoSubmit' ).on 'change', ->
      $(@).closest( 'form' ).trigger( 'submit' )

    #---------------------------------
    #
    #  Input Select
    #  -> Automatically select input text
    #
    #---------------------------------

    $('.js-inputSelect').on 'focus', ->
      $(@).trigger( 'select' )

    #---------------------------------
    #  Initialization
    #---------------------------------

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
