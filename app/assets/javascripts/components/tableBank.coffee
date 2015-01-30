#-------------------------------------
#
#  Table Bank
#  -> Responsive container for table overflow
#
#-------------------------------------
#
# options.context - the container element
# options.element - the element (jQuery)
# options.gutter - window gutter width (px)
#
#-------------------------------------

@Orientation.tableBank = (options) ->

  addEventListeners = (context) ->
    context.find('.js-tableBank-toggle').on 'click', (e) ->
      e.preventDefault()
      context.closest('.tableBank').toggleClass 'is-active'

  addStyleSheet = (width) ->
    gutter = options.gutter * 2

    $('head').append("
      <style>
        @media screen and (min-width: #{width + (gutter) }px) {

          .tableBank--#{width} .tableBank-original {
            display: block;
          }
        }

        @media screen and (max-width: #{width + (gutter) }px) {

          .tableBank.tableBank--#{width}.is-active .tableBank-original {
            display: none;
          }

        }
      </style>
    ")

  options.context.find(options.element).each ->
    element = $(@)
    originalTableElement = element.clone().addClass 'tableBank-original-table'
    width = element.width()

    messageText = "This table has been contained to fit, but you can <a href='#' class='js-tableBank-toggle' data-no-turbolink>toggle the original.</a>"
    originalBlock = "<div class='tableBank-original'><p class='tableBank-original-message'>#{messageText}</p></div>"

    element.wrap "<div class='tableBank tableBank--#{width}'></div>"
    element.before originalBlock

    if width > options.context.innerWidth()
      tableBankElement = element.closest '.tableBank'
      originalElement = tableBankElement.find '.tableBank-original'
      originalElement.append originalTableElement

      element.wrap '<div class="tableBank-container"></div>'

      addStyleSheet width
      addEventListeners tableBankElement
    else
      element.wrap '<div class="tableBank-container"></div>'
