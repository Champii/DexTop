class WindowManager

  layer: 0
  windows: {}
  baseX: 20
  baseY: 20

  constructor: (params) ->
    console.log 'WindowManager ctor'

    if not params.layer?
      throw new Error 'No layer defined'

    for name, param of params
      @[name] = param if @[name]?

  NewWindow: (win) ->
    @windows[win.wid] = new Window win, @layer

  # NewWindow: (params = {}) ->
  #   if not params.x?
  #     params.x = @baseX
  #     @baseX += 20
  #   if not params.y?
  #     params.y = @baseY
  #     @baseY += 20

  #   if not params.width?
  #     params.width = 200
  #   if not params.height?
  #     params.height = 200

  #   if not params.layer?
  #     params.layer = @layer

  #   win = new Window params
  #   @windows.push win
    # @emit 'new_window', win

