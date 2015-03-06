class DexTop

  constructor: ->
    @desktop = new DeskTop()
    @InitXpra()

  InitXpra: ->
    @xpra = new Xpra '172.16.42.177', 8080

    @xpra.on 'new-window', (clientWin) =>
      # console.log 'new win ?!', clientWin
      win = @desktop.NewWindow clientWin

      win.on 'click', (x, y) =>
        win.Focus()

      win.on 'focus', =>
        clientWin.Focus()

      win.on 'resize', (item) =>
        console.log 'RESIZE !!'
        clientWin.Resize item

      win.on 'move', (x, y) =>
      win.on 'minimize', =>
      win.on 'maximize', =>
      win.on 'draw', =>
      win.on 'close', =>

      #
      clientWin.on 'draw', =>
        win.emit 'draw'

      clientWin.on 'close', =>
        win.Close()

document.addEventListener "DOMContentLoaded", ->
  new DexTop
