screen_width = document.body.scrollWidth
screen_height = document.body.scrollHeight

get_desktop_size = ->
  [
    screen_width
    screen_height
  ]

get_screen_sizes = ->
  dpi = 96

  ###
  equivallent GTK code:
  monitor = plug_name, geom.x, geom.y, geom.width, geom.height, wmm, hmm
  monitors.append(monitor)

  screen = (screen.make_display_name(), screen.get_width(), screen.get_height(),
      screen.get_width_mm(), screen.get_height_mm(),
      monitors,
      work_x, work_y, work_width, work_height)
  ###

  wmm = Math.round(screen_width * 25.4 / dpi)
  hmm = Math.round(screen_height * 25.4 / dpi)
  monitor = [
    'Canvas'
    0
    0
    screen_width
    screen_height
    wmm
    hmm
  ]
  screen = [
    'HTML'
    screen_width
    screen_height
    wmm
    hmm
    [ monitor ]
    0
    0
    screen_width
    screen_height
  ]
  #just a single screen:
  [ screen ]

get_keycodes = ->
  #keycodes.append((nn(keyval), nn(name), nn(keycode), nn(group), nn(level)))
  keycodes = []
  kc = undefined
  for keycode of CHARCODE_TO_NAME
    kc = parseInt(keycode)
    keycodes.push [
      kc
      CHARCODE_TO_NAME[keycode]
      kc
      0
      0
    ]
  #show("keycodes="+keycodes.toSource());
  keycodes

get_keyboard_layout = ->
  v = window.navigator.userLanguage || window.navigator.language
  v = v.split(",")[0]
  l = v.split("-", 2)
  if l.length is 1
    l = v.split("_", 2)
  if l.length is 1
    return ""

  return l[1].toLowerCase()


class Xpra extends EventEmitter

  constructor: ->
    @ws = new Websock

    @ws.on 'open', (data) =>
      console.log 'open', data

      @proto = new Protocole @ws
      @proto.handlers['hello'] = (args) =>
        console.log 'GOT HELLO !'

      @proto.handlers['new-window'] = (args) =>
        console.log 'NEW WINDOW', args

        @emit 'new-window',
          wid: args[1]
          width: args[4]
          height: args[5]

        toSend = args[0..6]
        toSend[6] = args[7]
        toSend[0] = 'map-window'
        toSend[6]["encodings.rgb_formats"] = ["RGBX", "RGBA"]

        # toSend[4] /= 2
        # toSend[5] /= 2

        console.log args, toSend
        @proto.Send.apply @, toSend

      @proto.handlers['draw'] = (args) =>
        console.log 'Draw !'

        img = args[7]
        if typeof img is 'string'
          uint = new Uint8Array(img.length);
          for i in [0...img.length]
            uint[i] = img .charCodeAt(i);

          img  = uint;

        args[7] = new Zlib.Inflate(img).decompress();

        @emit 'test-draw', args

      @_SendHello()

    @ws.on 'close', (data) ->
      console.log 'close', data

    @ws.on 'error', (data) ->
      console.log 'err', data

    @ws.open 'ws://1.1.1.7:8080/', ['binary']

  _SendHello: ->
    @proto.Send 'hello',
      "version"         : "0.15.0",
      "platform"          : "linux2"
      "platform.name"       : "Linux"
      "platform.processor"    : "unknown"
      "platform.platform"     : navigator.appVersion
      "namespace"         : true
      "client_type"         : "HTML5"
      "share"           : false
      "auto_refresh_delay"    : 500
      "randr_notify"        : true
      "sound.server_driven"   : true
      "generic_window_types"    : true
      "server-window-resize"    : true
      "notify-startup-complete" : true
      "generic-rgb-encodings"   : true
      "window.raise"        : true
      "encodings"         : ["rgb"]
      "raw_window_icons"      : true
      #rgb24 is not efficient in HTML so don't use it:
      #png and jpeg will need extra code
      #"encodings.core"      : ["rgb24", "rgb32", "png", "jpeg"]
      "encodings.core"      : ["rgb32"]
      "encodings.rgb_formats"   : ["RGBX", "RGBA"]
      "encoding.generic"        : true
      "encoding.transparency"   : true
      "encoding.client_options" : true
      "encoding.csc_atoms"    : true
      "encoding.uses_swscale"   : false
      #video stuff we may handle later:
      "encoding.video_reinit"   : false
      "encoding.video_scaling"  : false
      "encoding.csc_modes"    : []
      #sound (not yet):
      "sound.receive"       : false
      "sound.send"        : false
      #compression bits:
      "zlib"            : true
      "lz4"           : false
      "compression_level"     : 0
      "compressible_cursors"    : true
      "encoding.rgb24zlib"    : true
      "encoding.rgb_zlib"     : true
      "encoding.rgb_lz4"      : false
      "bencode": true
      "windows"         : true
      #partial support:
      "keyboard"          : true
      "xkbmap_layout"       : get_keyboard_layout()
      "xkbmap_keycodes"     : get_keycodes()
      "desktop_size"        : get_desktop_size()
      "screen_sizes"        : get_screen_sizes()
      "dpi"           : 96
      #not handled yet, but we will:
      "clipboard_enabled"     : false
      "notifications"       : true
      "cursors"         : true
      "bell"            : true
      "system_tray"       : true
      #we cannot handle this (GTK only):
      "named_cursors"       : false
