class DexTop

  canvas: null
  windowManager: null
  systray: null
  height: document.body.scrollHeight
  width: document.body.scrollWidth

  constructor: ->
    console.log 'DexTop ctor'


    extend = (src, extended) ->
      for key, value of extended.prototype
        src::[key] = value

      for key, value of extended
        src[key] = value

      src

    fabric.Rect = extend fabric.Rect, EventEmitter

    @canvas = new fabric.Canvas 'render',
      width: @width
      height: @height
      backgroundColor: '#cccccc'

    @windowManager = new WindowManager
      canvas: @canvas
      parent: @

    @systray = new Systray
      canvas: @canvas
      parent: @

    @systray.on 'create_new_window', =>
      @windowManager.NewWindow()

    @canvas.getClickedInGroup = (group, mousePos, done) ->
      groupPos =
        x: group.getLeft()
        y: group.getTop()
        width: group.getWidth()
        height: group.getHeight()

      async.map group.getObjects(), (object, done) ->
        objectPos =
          xStart: groupPos.x + (group.width / 2) - Math.abs(object.getLeft())
          yStart: groupPos.y + (group.height / 2) - Math.abs(object.getTop())
          xEnd:   groupPos.x + (group.width / 2) - Math.abs(object.getLeft()) + object.getWidth()
          yEnd:   groupPos.y + (group.height / 2) - Math.abs(object.getTop()) + object.getHeight()

        if (mousePos.x >= objectPos.xStart && mousePos.x <= (objectPos.xEnd))
          if (mousePos.y >= objectPos.yStart && mousePos.y <= objectPos.yEnd)
            return done null, object

        return done()
      , (err, results) ->
        objs = group.getObjects()
        clicked = _(results).chain().reject((item) -> not item?).max((item) -> objs.indexOf item).value()

        done null, clicked

    @canvas.on 'mouse:down', (options) =>

      if (options.target)

        thisTarget = options.target;
        mousePos = @canvas.getPointer(options.e);

        thisTarget.bringToFront()

        if (thisTarget.isType('group'))
          @canvas.getClickedInGroup thisTarget, mousePos, (err, clicked) ->
            clicked.emit 'clicked', clicked if clicked.emit?

    @windowManager.on 'new_window', (win) =>
      @systray.AddWindow win

