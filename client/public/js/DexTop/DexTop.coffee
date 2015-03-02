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
    @xpra = new Xpra '1.1.1.7', 8080

    @xpra.on 'new-window', (win) =>
      console.log 'Win ?!', win
      @wm.NewWindow win
