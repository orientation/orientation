jQuery ($) ->

  delay = (ms, func) -> setTimeout func, ms

  submit_form = ->
    $('.js-search-form').submit()

  localize_datetimes = ->
    dates = $('.js-time')
    for date in dates
      old_time = $(date).attr('datetime')
      # NOTE: Affects date display in Article show page
      new_time = moment(old_time).format('MMMM D, YYYY')
      $(date).html(new_time)

  timeout = null

  $('.js-search-form').on 'keyup', ->
    guides   = $('.js-guides')
    articles = $('.js-article-list')

    if $('body').hasClass('guides-index')
      if $('.js-search-input').val() == ''
        guides.removeClass('dn')
        articles.addClass('dn')
      else
        guides.addClass('dn')
        articles.removeClass('dn')

    clearTimeout(timeout) if timeout
    timeout = delay 200, -> submit_form()

  $('html').on 'keydown','#article_content', (evt)->
    if evt.keyCode == 9
      $('textarea#article_content').insertAtCaret('  ')
      evt.preventDefault()

  $('#article_tag_tokens').tokenInput '/tags.json',
    prePopulate: $('#article_tag_tokens').data('load')
    preventDuplicates: true

  localize_datetimes()

  date_inputs = $("#article_created_at, #article_updated_at")
  for date in date_inputs
    date = $(date)
    default_date = $.datepicker.parseDate("yy-mm-dd", date.val())
    date.datepicker({ defaultDate: default_date, dateFormat: 'M dd yy' })
    old_time = date.val()
    new_time = moment(old_time).format('MMM Do YYYY')
    date.val(new_time)

  $(document).on "keyup", keyboardEventHandler

keyboardEventHandler = (event) ->
  # If user presses <f> or <s>
  if event.keyCode == 70 or event.keyCode == 83
    focusSearch()

  # If user presses <esc>
  if event.keyCode == 27
    unfocusSearch()

focusSearch = ->
  $('.js-search-input').trigger "focus"

# NOTE: Needed so <esc> blurs inputs in Firefox
unfocusSearch = ->
  $('.js-search-input').trigger "blur"
