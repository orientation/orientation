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
    #
    #  Table Bank
    #  -> Responsive container for table overflow
    #
    #---------------------------------

    tableBank = (options) ->
      options.context.find(options.element).each ->
        element = $(@)
        table = element.clone().addClass('tableBank-original-table').hide()
        width = element.width()

        messageText = "This table has been contained to fit, but you can <a href='#' class='js-tableBank-toggle' data-no-turbolink>toggle the original.</a>"
        originalBlock = "<div class='tableBank-original'><p class='tableBank-original-message'>#{messageText}</p></div>"

        element.wrap "<div class='tableBank tableBank--#{width}'></div>"
        element.before originalBlock

        if width > options.context.innerWidth()
          tableBankOriginal = element.closest('.tableBank').find('.tableBank-original')

          tableBankOriginal.append table

          element.wrap '<div class="tableBank-container"></div>'

          tableBankOriginal.find('.js-tableBank-toggle').on 'click', (e) ->
            e.preventDefault()
            tableBankOriginal.find('.tableBank-original-table').toggle()

          $('head').append("<style>@media screen and (min-width: #{width + (options.gutter * 2) }px) { .tableBank--#{width} .tableBank-original-message { display: block; } .tableBank--#{width} .tableBank-table { display: table; } }</style>")

    tableBank
      context: $('.markdown')
      element: $('table')
      gutter: '20'

  # Bind behavior to document load/reload
  # NOTE: Needed for Turbolinks compatibility
  $(document).ready domready
  $(document).on 'page:load', domready
