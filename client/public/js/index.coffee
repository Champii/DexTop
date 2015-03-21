class DexTop

  constructor: ->
    @desktop = new DeskTop()
    @InitXpra()

  InitXpra: ->
    @xpra = new Xpra '172.16.42.97', 8080

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
        # clientWin.Close()

      #server output
      clientWin.on 'draw', =>
        win.Draw()

      clientWin.on 'close', =>
        win.IsClosed()

      # clientWin.on 'focus', =>
      #   win.Focus()

document.addEventListener "DOMContentLoaded", ->
  new DexTop
