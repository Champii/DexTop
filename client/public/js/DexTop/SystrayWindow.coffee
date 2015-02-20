class SystrayWindow

  canvas: 0
  parent: 0


  constructor: (params) ->
    for name, param of params
      @[name] = param if @[name]?

