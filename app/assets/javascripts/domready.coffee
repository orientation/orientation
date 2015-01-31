# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  # ----- Components ----- #

  Orientation.accordion()
  Orientation.autoSubmit()
  Orientation.dropdown()
  Orientation.editor()
  Orientation.inputSelect()
  Orientation.tableBank.init()

  # ----- Vendor ----- #

  $( '#article_tag_tokens' ).tokenInput '/tags.json',
    prePopulate       : $( '#article_tag_tokens' ).data( 'load' )
    preventDuplicates : true
