$ ->
  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    console.log "submitted that damned form"
    $('.search-bar form').submit()

  timeout = null

  $('#search').on 'keyup', ->
    clearTimeout(timeout) if timeout
    timeout = delay 400, -> submit_form()

  $('html').on 'keydown','#article_content', (evt)->
    if evt.keyCode == 9
      keycode = evt.keycode
      evt.preventDefault()
      $('textarea#article_content').insertAtCaret('  ')

  $('#article_tag_tokens').tokenInput '/tags.json'
    theme: "facebook"
    prePopulate: $('#article_tag_tokens').data('load')

  return