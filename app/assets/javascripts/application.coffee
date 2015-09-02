# *************************************
#
#   Application
#   -> Compendium
#
# *************************************

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

# -------------------------------------
#   Cloudinary Uploads
# -------------------------------------

#= require jquery.ui.widget
#= require jquery.iframe-transport
#= require jquery.fileupload
#= require cloudinary/jquery.cloudinary
#= require attachinary

jQuery ($) ->

  $('.attachinary-input').attachinary(
    template: """
      <ul>
        <% for(var i=0; i<files.length; i++){ %>
          <li>
            <% if(files[i].resource_type == "raw") { %>
              <div class="raw-file"></div>
            <% } else { %>
              <img
                src="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "format": 'jpg', "crop": 'fill', "width": 100, "height": 100 }) %>"
                alt="" width="100" height="100" />
                <input type="text" id="" value="![](<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "format": 'jpg'}) %>)" size="50">
            <% } %>
            <a href="<%= $.cloudinary.url(files[i].public_id, { "version": files[i].version, "format": 'jpg'}) %>" target="_blank">Preview</a>
            or
            <a href="#" data-remove="<%= files[i].public_id %>">Remove</a>
          </li>
        <% } %>
      </ul>
    """
  )

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
