Nodulator = require 'nodulator'
Server = require './server'

Assets = require 'nodulator-assets'

Nodulator.Use Assets

Nodulator.assets.AddFoldersRec
  '/js/app.js': ['/client/public/js/DexTop/', '/client/public/js/xpra/']

Server.Init()
Nodulator.Run()
