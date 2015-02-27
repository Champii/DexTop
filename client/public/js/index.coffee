# B = document.body
# height = B.scrollHeight
# width = B.scrollWidth

# canvas = new fabric.Canvas 'render',
#   width: width
#   height: height

# rect = new fabric.Rect
#   left: 100
#   top: 100
#   fill: 'red'
#   width: 20
#   height: 20
#   # hasBorders: false
#   # hasControls: false

# canvas.add rect

# if (!window.location.getParameter ) {
#   window.location.getParameter = function(key) {
#     function parseParams() {
#         var params = {},
#             e,
#             a = /\+/g,  // Regex for replacing addition symbol with a space
#             r = /([^&=]+)=?([^&]*)/g,
#             d = function (s) { return decodeURIComponent(s.replace(a, " ")); },
#             q = window.location.search.substring(1);

#         while (e = r.exec(q))
#             params[d(e[1])] = d(e[2]);

#         return params;
#     }

#     if (!this.queryStringParams)
#         this.queryStringParams = parseParams();

#     return this.queryStringParams[key];
#   };
# }


in_array = (needle, haystack) ->
  found = 0;
  len = haystack.length
  for i in [0...len]
    if haystack[i] is needle
      return i

    found++
  return -1

get_bool = (v, default_value) ->
  if (in_array(v, ["true", "on", true])>=0)
    return true;
  if (in_array(v, ["false", false])>=0)
    return false;
  return default_value;


ValidIpAddressRegex = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/;
ValidHostnameRegex = /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/;
parse_host = (s) ->
  if (s==null || s.length==0)
    return "";
  if (s.match(ValidIpAddressRegex) || s.match(ValidHostnameRegex))
    return s;
  set_ui_message("invalid host string", "red");
  return "";



get_keyboard_layout = ->
  v = window.navigator.userLanguage || window.navigator.language;
  v = v.split(",")[0];
  l = v.split("-", 2);
  if (l.length==1)
    l = v.split("_", 2);
  if (l.length==1)
    return "";
  return l[1].toLowerCase();


guess_platform_processor = ->
  if (navigator.oscpu)
    return navigator.oscpu;
  if (navigator.cpuClass)
    return navigator.cpuClass;
  return "unknown";


guess_platform_name = ->
  #use python style strings for platforms:
  if (navigator.appVersion.indexOf("Win")!=-1)
    return "Microsoft Windows";
  if (navigator.appVersion.indexOf("Mac")!=-1)
    return "Mac OSX";
  if (navigator.appVersion.indexOf("Linux")!=-1)
    return "Linux";
  if (navigator.appVersion.indexOf("X11")!=-1)
    return "Posix";
  return "unknown";


guess_platform = ->
  #use python style strings for platforms:
  if (navigator.appVersion.indexOf("Win")!=-1)
    return "win32";
  if (navigator.appVersion.indexOf("Mac")!=-1)
    return "darwin";
  if (navigator.appVersion.indexOf("Linux")!=-1)
    return "linux2";
  if (navigator.appVersion.indexOf("X11")!=-1)
    return "posix";
  return "unknown";



class Protocole

  constructor: (@ws) ->

  Send: (message...) ->
    console.log 'mess', message
    bdata = bencode(message)
    console.log 'bdata', bdata
    #convert string to a byte array:
    cdata = []
    for i in [0...bdata.length]
      cdata.push(bdata[i].charCodeAt 0)
    level = 0

    ###
    use_zlib = false   #does not work...
    if (use_zlib) {
      cdata = new Zlib.Deflate(cdata).compress()
      level = 1
    }
    ###
    len = cdata.length
    #struct.pack('!BBBBL', ord("P"), proto_flags, level, index, payload_size)
    header = ["P".charCodeAt(0), 0, level, 0]
    for i in [3...0]
      header.push((len >> (8*i)) & 0xFF);

    #concat data to header, saves an intermediate array which may or may not have
    #been optimised out by the JS compiler anyway, but it's worth a shot
    header = header.concat(cdata);

    #debug("send("+message+") "+data.byteLength+" bytes in message for: "+bdata.substring(0, 32)+"..");
    @ws.send(header);



document.addEventListener "DOMContentLoaded", ->

  # dexTop = new DexTop()
  proto = null
  test = new WebSocket 'ws://1.1.1.7:8080/', ['binary', 'base64']
  test.onopen = (data) ->
    console.log 'open', data

    proto = new Protocole test

    proto.Send 'hello',
      "version"         : "0.15.0",
      "platform"          : guess_platform(),
      "platform.name"       : guess_platform_name(),
      "platform.processor"    : guess_platform_processor(),
      "platform.platform"     : navigator.appVersion,
      "namespace"         : true,
      "client_type"         : "HTML5",
      "share"           : false,
      "auto_refresh_delay"    : 500,
      "randr_notify"        : false,
      "sound.server_driven"   : false,
      "generic_window_types"    : false,
      "server-window-resize"    : false,
      "notify-startup-complete" : false,
      "generic-rgb-encodings"   : false,
      "window.raise"        : false,
      # "encodings"         : ["rgb"],
      "raw_window_icons"      : false,
      #rgb24 is not efficient in HTML so don't use it:
      #png and jpeg will need extra code
      #"encodings.core"      : ["rgb24", "rgb32", "png", "jpeg"],
      # "encodings.core"      : ["rgb32"],
      # "encodings.rgb_formats"   : ["RGBX", "RGBA"],
      "encoding.generic"        : false,
      "encoding.transparency"   : false,
      "encoding.client_options" : false,
      "encoding.csc_atoms"    : false,
      "encoding.uses_swscale"   : false,
      #video stuff we may handle later:
      "encoding.video_reinit"   : false,
      "encoding.video_scaling"  : false,
      "encoding.csc_modes"    : [],
      #sound (not yet):
      "sound.receive"       : false,
      "sound.send"        : false,
      #compression bits:
      "zlib"            : false,
      "lz4"           : false,
      "compression_level"     : 1,
      "compressible_cursors"    : false,
      "encoding.rgb24zlib"    : false,
      "encoding.rgb_zlib"     : false,
      "encoding.rgb_lz4"      : false,
      "windows"         : false,
      #partial support:
      "keyboard"          : false,
      # "xkbmap_layout"       : get_keyboard_layout(),
      # "xkbmap_keycodes"     : get_keycodes(),
      # "desktop_size"        : get_desktop_size(),
      # "screen_sizes"        : get_screen_sizes(),
      "dpi"           : 96,
      #not handled yet, but we will:
      "clipboard_enabled"     : false,
      "notifications"       : false,
      "cursors"         : false,
      "bell"            : false,
      "system_tray"       : false,
      #we cannot handle this (GTK only):
      "named_cursors"       : false,


  test.onclose = (data) ->
    console.log 'close', data

  test.onmessage = (data) ->
    u8 = new Uint8Array(data);
    console.log c for c in u8
    console.log 'mess', u8

  test.onerror = (data) ->
    console.log 'err', data


  # server = new Server()

  # server.resize(100,100)

  # # document.getElementById('tamere').appendChild server.elem

  # # client = server.connect()


  # # server = res.server;
  # connection = server.connect();
  # display = connection.display;

  # display.changeAttributes({ windowId: display.rootWindowId, backgroundColor: '#354763' });
  # display.invalidateWindow({ windowId: display.rootWindowId });

  # # ch1 = new Crosshairs(server);
  # # display.configureWindow({ windowId: ch1.windowId, width: 150, height: 150 });
  # # DemoCommon.centerWindow(display, ch1.windowId);
  # # display.mapWindow({ windowId: ch1.windowId });

  # # DemoCommon.addInspector(res);

  # dexTop.windowManager.NewWindow
  #   pixmap: server.elem
  #   width: 100
  #   height: 100

  # console.log dexTop
, false
