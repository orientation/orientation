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
    Orientation.editor()
    Orientation.inputSelect()

    Orientation.tableBank
      context : $('.markdown')
      element : $('table')
      gutter  : '20'

  # -------------------------------------
  #   Turbolinks & DOM Ready Handlers
  # -------------------------------------

  $( document ).ready( domready )
  $( document ).on( 'page:load', domready )
