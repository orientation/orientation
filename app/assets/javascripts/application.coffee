# *************************************
#
#   Application
#   -> Compendium
#
# *************************************

# -------------------------------------
#   Vendor
# -------------------------------------

#= require jquery
#= require jquery.tokeninput
#= require jquery_ujs
#= require moment

# -------------------------------------
#   Base
# -------------------------------------

#= require orientation

# -------------------------------------
#   Components
# -------------------------------------

#= require_tree ./components

# -------------------------------------
#   Document Ready
# -------------------------------------

#= require domready

# -------------------------------------
#   Self
# -------------------------------------

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

  localize_datetimes()

  # ----- Table of Contents ----- #

  tocElement = $( '.js-toc' )

  tocElement.find( 'ul' ).addClass( 'list list--s' )
  tocElement.children( 'ul' ).addClass( 'list--divided list--divided--s mbm' )
  tocElement.find( 'ul' ).find( 'ul' ).addClass( 'mlm mts' )
  tocElement.find( 'li' ).addClass( 'list-item tsm' )
