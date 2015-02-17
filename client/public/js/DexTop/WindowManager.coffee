class WindowManager

  windows: []

  constructor: ->
    console.log 'WindowManager ctor'
    @NewWindow 'lol'

  NewWindow: (title) ->
    @windows.push new Window title

