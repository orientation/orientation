#-------------------------------------
#  DOM Ready
#  - Runs globally when the document
#    is ready or when a new page is
#    requested via Turbolinks
#-------------------------------------

jQuery ($) ->

  domready = ->

    #---------------------------------
    #
    #  Dropdown
    #  -> Contextual menus
    #
    #---------------------------------

    $('.js-dropdown-btn').on 'click', (e) ->
      e.stopPropagation() # NOTE: Needed to prevent trigger click event on document
      $(@).closest('.js-dropdown').toggleClass('is-active')

    # TODO: Modularize clickout behavior
    $(document).on 'click', ->
      $('.js-dropdown').removeClass('is-active')

    #---------------------------------
    #
    #  Accordion
    #  -> Collapsable container
    #
    #---------------------------------

    # Collapse accordion content on DOM Ready
    $('.js-accordion-content').hide()

    $('.js-accordion-btn').on 'click', (e) ->
      $(@).closest('.js-accordion').find('.js-accordion-content').slideToggle()

    #---------------------------------
    #
    #  Guide Cleanup
    #  -> Apply classes to guides
    #
    #---------------------------------

    $('.js-guides').find('ol, ul').addClass('list list--xs')
    $('.js-guides').find('ol ol, ul ul').addClass('plm')
    $('.js-guides').find('li').addClass('list-item')
    $('.js-guides').children('li').addClass('mbm')

    #---------------------------------
    #
    #  Input Select
    #  -> Automatically select input text
    #
    #---------------------------------

    $('.js-input-select').on 'click', ->
      $(@).focus().select()

    #---------------------------------
    #  Initialization
    #---------------------------------

    Orientation.tableBank
      context: $('.markdown')
      element: $('table')
      gutter: '20'

    # -------------------------------------
    #   Fullscreen Editor
    # -------------------------------------

    $.fn.redraw = ->
      $(@).each ->
        redraw = this.offsetHeight

    $('.js-editor-open').on 'click', (event) ->
      event.preventDefault()

      $('.js-editor-textarea')
        .addClass('is-editing')
        .parent('.js-editor-overlay')
        .addClass('is-active')

      setTimeout do $('.js-editor-textarea').focus(), 50

    $(document).on 'click', '.js-editor-close', (event) ->
      event.preventDefault()

      $('.js-editor-overlay').removeClass('is-active')
      $('.js-editor-textarea').removeClass('is-editing').focus()

  # Bind behavior to document load/reload
  # NOTE: Needed for Turbolinks compatibility
  $(document).ready domready
  $(document).on 'page:load', domready
