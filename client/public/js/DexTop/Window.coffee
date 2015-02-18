class Window

  x: 0
  y: 0
  width: 0
  height: 0
  title: ''
  canvas: 0
  borderSize: 5
  titleHeight: 20

  constructor: (params) ->
    console.log 'Window ctor'

    for name, param of params
      @[name] = param if @[name]?



    @winBack = new fabric.Rect
      fill: '#777777'
      width: @width
      height: @height
      # hasBorders: true
      # hasControls: true

    @winFront = new fabric.Rect
      left: @borderSize
      top: @titleHeight
      fill: '#888888'
      width: @width - @borderSize * 2
      height: @height - @borderSize - @titleHeight
      originX: 'left'
      originY: 'top'

    @win = new fabric.Group [@winBack, @winFront],
      left: @x
      top: @y
      width: @width
      height: @height
      hasBorders: false
      centeredScaling: false
      # hasControls: false
      # evented: false

    @win.on 'scaling', (event) =>

      console.log @win.getScaleX(), @win.getScaleY()
      @win.width = @win.getWidth() * @win.getScaleX()
      @win.height = @win.getHeight() * @win.getScaleY()
      # @win.scaleX = 1
      # @win.scaleY = 1

      # console.log '1', @winFront.left
      # @winFront.setLeft @winFront.left * (1 / @win.scaleX)
      # console.log '2', @winFront.left
      # @winFront.setScaleY @win.scaleY / 2

      # console.log @winFront.getWidth(), @winFront.getWidth() - (@borderSize * 2)
      # @winFront.width = @winFront.getWidth()# - (@borderSize * 2)
      # console.log @winFront.getWidth()
      # @width = @win.getWidth()
        # height: @height - @borderSize - @titleHeight
      # console.log 'Window scalling !', event.e.clientX, event.e.clientY, event.e.x, event.e.y

    @canvas.add @win

  # Move: (dest) ->
