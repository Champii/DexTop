class Window

  x: 0
  y: 0
  width: 100
  height: 100
  layer: 0
  image: 0
  offscreen: 0

  constructor: (params) ->

    if not params.layer?
      throw new Error 'No layer defined'

    for name, param of params
      @[name] = param if @[name]?

    @group = new Kinetic.Group
      x: @x
      y: @y
      stroke: 'black'
      strokeWidth: 4
      cornerRadius: 20
      shadow:
        color: "blue"
        blur: 12
        offset: [8, 8]
        opacity: 0.7

    @title = new Kinetic.Rect
      x: 0
      y: 0
      width: @width
      height: 20
      fill: 'green'

    @title.on 'mousedown', (e) =>
      document.body.style.cursor = 'pointer';
      @group.draggable true

    @title.on 'mouseup', (e) =>
      document.body.style.cursor = 'default';
      @group.draggable false

    @image = new Image
    @content = new Kinetic.Image
      x: 0
      y: 20
      width: @width
      height: @height
      image: @image

    @group.add @title
    @group.add @content

    @layer.add @group
    @layer.draw()

    @offscreen = document.createElement('canvas')

  Draw: (attrs) ->
    console.log 'Draw', attrs

    wid = attrs[1]
    x = attrs[2]
    y = attrs[3]
    width = attrs[4]
    height = attrs[5]
    coding = attrs[6]
    data = attrs[7]
    paquet_sequence = attrs[8]
    rowstride = attrs[9]

    ctx = @offscreen.getContext('2d')

    image = ctx.createImageData width, height
    # image = ctx.getImageData x, y, @width, @height

    image.data.set data, image.width * 4 * y

    ctx.putImageData image, x, y

    @layer.getContext()._context.putImageData image, x, y

    img = new Image

    img.onload = =>
      console.log image, img.src
      @content.setImage img
      @layer.draw()

    # img.src = @layer.getContext().canvas.toDataURL()
    img.src = @offscreen.toDataURL('image/jpeg', 1)
