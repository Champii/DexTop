class DexTop

  constructor: ->
    @desktop = new DeskTop()
    @InitXpra()

  InitXpra: ->
    @xpra = new Xpra '172.16.42.177', 8080

    @xpra.on 'new-window', (clientWin) =>
      # console.log 'new win ?!', clientWin
      win = @desktop.NewWindow clientWin

      #user input
      win.on 'mousedown', (params) =>
        win.Focus()
        clientWin.MouseDown params

      win.on 'mouseup', (params) =>
        clientWin.MouseUp params

      win.on 'mousemove', (params) =>
        clientWin.MouseMove params

      win.on 'focus', =>
        clientWin.Focus()

      win.on 'resize', (item) =>
        clientWin.ResizeMove item

      win.on 'move', (item) =>
        clientWin.ResizeMove item

      win.on 'minimize', =>
      win.on 'maximize', =>
      win.on 'draw', =>
      win.on 'close', =>

      #server output
      clientWin.on 'draw', =>
        win.emit 'draw'

      clientWin.on 'close', =>
        win.Close()

document.addEventListener "DOMContentLoaded", ->
  new DexTop
