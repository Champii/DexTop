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

document.addEventListener "DOMContentLoaded", ->

  new DexTop()

  server = new Server()

  server.resize(100,100)

  document.getElementById('tamere').appendChild server.elem

  # client = server.connect()


  # server = res.server;
  connection = server.connect();
  display = connection.display;

  display.changeAttributes({ windowId: display.rootWindowId, backgroundColor: '#354763' });
  display.invalidateWindow({ windowId: display.rootWindowId });

  ch1 = new Crosshairs(server);
  display.configureWindow({ windowId: ch1.windowId, width: 150, height: 150 });
  # DemoCommon.centerWindow(display, ch1.windowId);
  display.mapWindow({ windowId: ch1.windowId });

  # DemoCommon.addInspector(res);


  # console.log dexTop
, false
