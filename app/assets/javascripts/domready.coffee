# *************************************
#
#   Document Ready
#
# *************************************

jQuery ($) ->

  # ----- Functions ----- #

  Orientation.accordion()
  Orientation.autoSubmit()
  Orientation.dropdown()
  Orientation.headingLink()
  Orientation.shortcut()

  Orientation.search
    hiddenClass : 'dn'

  # ----- Modules ----- #

  Orientation.editor.init()
  Orientation.selectText.init()
  Orientation.tableBank.init()

  # ----- Vendor ----- #

  # Bootstrap

  $( '[data-toggle="tooltip"]' ).tooltip
    container : 'body'

  # jquery-ujs

  $( '#article_tag_tokens' ).tokenInput '/tags.json',
    prePopulate       : $( '#article_tag_tokens' ).data( 'load' )
    preventDuplicates : true
