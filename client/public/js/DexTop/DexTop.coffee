class DexTop

  canvas: null
  windowManager: null
  systray: null
  height: document.body.scrollHeight
  width: document.body.scrollWidth

  constructor: ->
    console.log 'DexTop ctor'

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



