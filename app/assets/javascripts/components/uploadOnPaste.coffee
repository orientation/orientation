@Orientation.uploader = ( options ) ->
  # settings = $.extend
  #   $element : $( '.js-accordion' )
  #   $content : $( '.js-accordion-content' )
  # , options

  defaults =
    callback: $.noop
    matchType: /image.*/

  $.fn.uploadOnPaste = (options) ->
    if typeof options == "function"
      options =
        callback: options

    options = $.extend({}, defaults, options)

    this.each ->
      element = this
      $this = $(this)

      $this.on 'dragover', (event) ->
        event.preventDefault()

      $this.on 'dragenter', (event) ->
        event.preventDefault()
        $(this).css('background','green')

      $this.on 'dragleave', (event) ->
        $(this).css('background','red')

      $this.on 'drop', (event) ->
        event.preventDefault()
        $(this).css('background','yellow')

      $this.bind 'paste', (event) ->
        found = false
        clipboardData = event.originalEvent.clipboardData

        Array::forEach.call clipboardData.types, (type, i) ->
          return if found

          if type.match(options.matchType) or clipboardData.items[i].type.match(options.matchType)
            file = clipboardData.items[i].getAsFile()

            reader = new FileReader()

            reader.onload = (evt) ->
              options.callback.call element,
                dataURL: evt.target.result
                event: evt
                file: file
                name: file.name

            reader.readAsDataURL(file)

            found = true

