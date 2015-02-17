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

, false
