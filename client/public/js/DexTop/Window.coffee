class Window

  x: 0
  y: 0
  width: 0
  height: 0
  title: ''
  canvas: 0
  borderSize: 5
  titleHeight: 20
  pixmap: 0

  constructor: (params) ->
    console.log 'Window ctor'

    for name, param of params
      @[name] = param if @[name]?

    @winBack = new fabric.Rect
      fill: '#777777'
      width: @width + @borderSize * 2
      height: @height + @borderSize + @titleHeight
      _name: 'winBack'
      # hasBorders: true
      # hasControls: true


    console.log @pixmap
    @winFront = 0
    if @pixmap

      return fabric.Image.fromURL @pixmap.children[0].toDataURL({format: 'jpeg', multiplier: 1}), (img) =>
        console.log 'pfff', img
        img.left = @borderSize
        img.top = @titleHeight

        @winFront = img
        @win = new fabric.Group [@winBack, @winFront],
          left: @x
          top: @y
          width: @width + @borderSize * 2
          height: @height + @borderSize + @titleHeight
          hasBorders: false
          _name: 'winGroup'
          hasControls: false

        @canvas.add @win
      # @winFront = new fabric.Image @pixmap.children[0].toDataURL({format: 'jpeg', multiplier: 1}),
      #   left: @borderSize
      #   top: @titleHeight
      #   width: @width - @borderSize * 2
      #   height: @height - @borderSize - @titleHeight
      # console.log 'Yeah', @winFront
    else
      @winFront = new fabric.Rect
        left: @borderSize
        top: @titleHeight
        fill: '#888888'
        width: @width
        height: @height
        # width: @width - @borderSize * 2
        # height: @height - @borderSize - @titleHeight
        _name: 'winFront'


    @win = new fabric.Group [@winBack, @winFront],
      left: @x
      top: @y
      width: @width + @borderSize * 2
      height: @height + @borderSize + @titleHeight
      hasBorders: false
      _name: 'winGroup'
      hasControls: false

    @canvas.add @win

  # Move: (dest) ->
