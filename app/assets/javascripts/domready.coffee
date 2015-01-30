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
    Orientation.tableBank.init()

  # -------------------------------------
  #   Turbolinks & DOM Ready Handlers
  # -------------------------------------

  $( document ).ready( domready )
  $( document ).on( 'page:load', domready )
