class Systray

  canvas: 0
  parent: 0
  height: 25
  width:0
  x: 0
  y: 0

  constructor: (params) ->
    console.log 'Systray ctor'

    for name, param of params
      @[name] = param if @[name]?

    @width = @parent.width

    @y = @parent.height - @height

    @tray = new fabric.Rect
      left: @x
      top: @y
      height: @height
      width: @width
      fill: '#444444'

    @canvas.add @tray

