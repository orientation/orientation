#= require rails-ujs
#= require orientation
#= require_tree ./components
#= require domready
#= require_self

# -------------------------------------
#   Inbox
# -------------------------------------

jQuery ($) ->

  # ----- Localize Datetimes ----- #

  localize_datetimes = ->
    dates = $( '.js-time' )

    for date in dates
      old_time = $(date).attr('datetime')
      # NOTE: Affects date display in Article show page
      new_time = moment(old_time).format('MMMM D, YYYY')
      $(date).html(new_time)


  # ----- Relativize Datetimes ----- #

  relativize_datetimes = ->
    dates = $( '.js-relative-time' )

    for date in dates
      old_time = $(date).attr('datetime')
      # NOTE: Affects date display in Article show page
      new_time = moment(old_time).fromNow()
      $(date).html(new_time)

  relativize_datetimes()

  # ----- Table of Contents ----- #

  tocElement = $( '.js-toc' )

  tocElement.find( 'ul' ).addClass( 'list list--s' )
  tocElement.children( 'ul' ).addClass( 'list--divided list--divided--s mbm' )
  tocElement.children( 'ul' ).children( 'li' ).addClass( 'tsm' )
  tocElement.find( 'ul' ).find( 'ul' ).addClass( 'mlm mts' )
  tocElement.find( 'li' ).addClass( 'list-item' )
