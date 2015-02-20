class WindowManager extends EventEmitter

  canvas: 0
  parent: 0
  windows: []
  baseX: 20
  baseY: 20

  constructor: (params) ->
    console.log 'WindowManager ctor'

    for name, param of params
      @[name] = param if @[name]?

    @NewWindow
      canvas: @canvas
      title: 'lol'

  NewWindow: (params = {}) ->
    if not params.x?
      params.x = @baseX
      @baseX += 20
    if not params.y?
      params.y = @baseY
      @baseY += 20

    if not params.width?
      params.width = 200
    if not params.height?
      params.height = 200

    if not params.canvas?
      params.canvas = @canvas

    win = new Window params
    @windows.push win

    @emit 'new_window', win
