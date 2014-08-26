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

  # Bind behavior to document load/reload
  # NOTE: Needed for Turbolinks compatibility
  $(document).ready domready
  $(document).on 'page:load', domready
