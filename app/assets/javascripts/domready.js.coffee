#-------------------------------------
#  DOM Ready
#  - Runs globally when the document
#    is ready or when a new page is
#    requested via Turbolinks
#-------------------------------------

# TODO: Modularize clickout behavior
jQuery ($) ->

  domready = ->

    # Event listeners
    $('.js-dropdown-btn').on 'click', (e) ->
      e.stopPropagation()
      $(@).closest('.js-dropdown').toggleClass('is-active')

    $(document).on 'click', ->
      $('.js-dropdown').removeClass('is-active')

  # Bind behavior to document load/reload
  $(document).ready domready
  $(document).on 'page:load', domready
