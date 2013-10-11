# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#make-fresh').click (e) ->
	  e.preventDefault()
	  article_id = $(this).attr('data-id')

	  $.ajax(
	    type: 'PUT'
	    url: '/articles/' + article_id + '/make_fresh'
	    dataType: 'json'
	   ).done ->
  	 		$('.stale').remove()
  	 		$('#make-fresh').remove()
  	 		$('#stale-fresh').append '<span class="state fresh">fresh</span>'


