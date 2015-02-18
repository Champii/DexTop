class WindowManager

  canvas: 0
  parent: 0
  windows: []

  constructor: (params) ->
    console.log 'WindowManager ctor'

    for name, param of params
      @[name] = param if @[name]?

    #test
    @NewWindow
      canvas: @canvas
      title: 'lol'
      x: 150
      y: 150
      width: 100
      height: 100

  NewWindow: (params) ->
    @windows.push new Window params

