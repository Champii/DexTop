class Window

  # x: 0
  # y: 0
  # width: 100
  # height: 100
  # layer: 0
  # image: 0
  # offscreen: 0

  constructor: (@client, @layer) ->

    # console.log 'Window !', @client, @layer

    # if not params.layer?
    #   throw new Error 'No layer defined'

    @group = new Kinetic.Group
      x: @client.x
      y: @client.y
      stroke: 'black'
      strokeWidth: 4
      cornerRadius: 20

    @title = new Kinetic.Rect
      x: 0
      y: 0
      width: @client.width
      height: 20
      fill: 'green'

    @title.on 'mousedown', (e) =>
      document.body.style.cursor = 'pointer';
      @group.draggable true

    @title.on 'mouseup', (e) =>
      document.body.style.cursor = 'default';
      @group.draggable false

    @content = new Kinetic.Shape
      sceneFunc: (ctx) =>
        ctx.putImageData @client.offscreen.getContext('2d').getImageData(0, 0, @client.width, @client.height), @group.getX(), @group.getY() + @title.getHeight()
        ctx.fillStrokeShape(@content);
        # console.log 'lol', ctx
      x: 0
      y: 20
      width: @client.width
      height: @client.height
      # image: @image
      # shadow:
      #   color: "blue"
      #   blur: 12
      #   offset: [8, 8]
      #   opacity: 0.7

    @group.add @title
    @group.add @content

    @layer.add @group
    @layer.draw()

    @client.on 'drawn', (region) =>
      # @content.getContext().putImageData @client.offscreen.getContext('2d').getImageData(region.x, region.y, region.width, region.height), region.x, region.y
      @content.draw()
      @title.draw()
      # img = new Image

      # @layer.getContext()._context.putImageData @client.offscreen.getContext('2d').getImageData(@client.x, @client.y, @client.width, @client.height), @client.x, @client.y
      # console.log 'tamere', @client.offscreen.getContext('2d').getImageData(@client.x, @client.y, @client.width, @client.height)
      # img.onload = =>
        # console.log image, img.src
        # @content.setImage img
        # console.log 'img dta race', img

        #TEST
      # img.src = @client.offscreen.toDataURL()

  # Draw: (params) ->
  #   console.log 'Draw', params

  #   ctx = @client.offscreen.getContext('2d')

