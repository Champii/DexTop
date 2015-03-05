class DexTop

  constructor: ->
    @desktop = new DeskTop()
    @InitXpra()
    @InitEvents()

  InitXpra: ->
    @xpra = new Xpra '1.1.1.7', 8080

    @xpra.on 'new-window', (params) =>
      console.log 'new win ?!', params
      win = @desktop.NewWindow params

      win.on 'click', (x, y) =>
      win.on 'focus', =>
      win.on 'move', (x, y) =>
      win.on 'minimize', =>
      win.on 'maximize', =>
      win.on 'draw', =>
      win.on 'close', (x, y) =>

  InitEvents: ->
    @desktop.NewWindow
      height: 0
      width: 0
      width: 300
      height: 300

document.addEventListener "DOMContentLoaded", ->
  new DexTop
