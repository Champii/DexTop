class Systray extends EventEmitter

  canvas: 0
  parent: 0
  height: 25
  width:0
  x: 0
  y: 0
  windows: []
  button: 0

  constructor: (params) ->
    console.log 'Systray ctor'

    for name, param of params
      @[name] = param if @[name]?

    @width = @parent.width

    @y = @parent.height - @height

    @bar = new fabric.Rect
      left: 0
      top: 0
      height: @height
      width: @width
      fill: '#555555'
      _name: 'tray bar'

    @button = new fabric.Rect
      left: 5
      top: 5
      height: @height - 10
      width: 30
      fill: '#111111'
      evented: true
      _name: 'tray button'
      # parent: @

    @button.on 'clicked', =>
      @emit 'create_new_window'

    @tray = new fabric.Group [@bar, @button],
      left: @x
      top: @y
      hasControls: false
      hasBorders: false
      selectable: false
      # _name: 'tray'

    @canvas.add @tray

      # console.log 'Button Clicked !'

  AddWindow: (win) ->
    @windows.push win


