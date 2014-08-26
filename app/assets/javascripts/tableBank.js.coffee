#-------------------------------------
#
#  Table Bank
#  -> Responsive container for table overflow
#
#-------------------------------------

@Orientation.tableBank = (options) ->
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

