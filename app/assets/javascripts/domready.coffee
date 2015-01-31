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
  Orientation.search()
  Orientation.tableBank.init()

  Orientation.search
    element        : $( '.js-articleSearch' )
    formElement    : $( '.js-articleSearch-form' )
    inputElement   : $( '.js-articleSearch-input' )
    resultsElement : $( '.js-articleSearch-results' )
    callback       : ( settings ) ->
      guidesElement = $( '.js-guideList' )

      if settings.inputElement.val()
        guidesElement.addClass( 'dn' )
        settings.resultsElement.removeClass( 'dn' )
      else
        guidesElement.removeClass( 'dn' )
        settings.resultsElement.addClass( 'dn' )

  # ----- Vendor ----- #

  $( '#article_tag_tokens' ).tokenInput '/tags.json',
    prePopulate       : $( '#article_tag_tokens' ).data( 'load' )
    preventDuplicates : true
