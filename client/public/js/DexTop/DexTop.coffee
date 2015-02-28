class DexTop

  constructor: ->
    @InitKinetic()
    @InitXpra()

  InitKinetic: ->
    @stage = new Kinetic.Stage
      container: 'render'
      height: document.body.scrollHeight
      width: document.body.scrollWidth

    layer = new Kinetic.Layer

    @stage.add layer

    @wm = new WindowManager
      layer: layer

    document.getElementsByTagName('canvas')[0].style.background = '#BBBBBB'

  InitXpra: ->
    @xpra = new Xpra

    @xpra.on 'new-window', (attrs) =>
      @wm.NewWindow attrs

    @xpra.on 'test-draw', (attrs) =>
      @wm.windows[0].Draw attrs
