# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  documentReady = ->
    Orientation.accordion()
    Orientation.autoSubmit()
    Orientation.dropdown()
    Orientation.editor()
    Orientation.inputSelect()
    Orientation.tableBank.init()

  # -------------------------------------
  #   Set Event Handlers
  # -------------------------------------

  $( document ).on
    'ready'     : documentReady
    'page:load' : documentReady
