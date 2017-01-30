@Orientation.uploader = ->
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
        # prevent default when items are being dragged over the element
        event.preventDefault()

      $this.on 'dragenter', (event) ->
        # prevent default when dragged objects enter the area over the element
        event.preventDefault()
        # change the border color to denote that dropping is an available action
        $(this).css('border','1px solid greenyellow')

      $this.on 'dragleave', (event) ->
        # restore the border color back to its default when dragged objects
        # leave the area directly over the element
        $(this).css('border','')

      $this.on 'drop', (event) ->
        # prevent the default otherwise dropping an object would cause it to
        # be loaded in a new browser tab
        event.preventDefault()

        # restore the border color back it its default when dragged objects are
        # dropped into the element area
        $(this).css('border','')

        # interate over dropped files and check if their file type matches the
        # types we defined in our default matchType options
        for file, index in event.originalEvent.dataTransfer.files
          if file.type.match(options.matchType)
            # create FileRead in order to read the contents of the current file
            reader = new FileReader()

            # define a callback to fire when the reader is done reading the file
            # it will give us access to the file name, file data, and its dataURL
            reader.onload = (event) ->
              options.callback.call element,
                dataURL: event.target.result
                event: event
                file: file
                name: file.name

            # tell the FileReader instance to start reading the file which will
            # eventually fire the onload callback.
            reader.readAsDataURL(file)

      $this.bind 'paste', (event) ->
        found = false
        clipboardData = event.originalEvent.clipboardData

        for type, index in clipboardData.types
          return if found

          if type.match(options.matchType) or clipboardData.items[index].type.match(options.matchType)
            file = clipboardData.items[index].getAsFile()

            reader = new FileReader()

            reader.onload = (event) ->
              options.callback.call element,
                dataURL: event.target.result
                event: event
                file: file
                name: file.name

            reader.readAsDataURL(file)

            found = true

