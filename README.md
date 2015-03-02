# DexTop
Implements a desktop system in a cloud (DAAS) in coffeescript for modern browsers.

Under heavy development

Powered by [Nodulator](https://github.com/Champii/Nodulator)

Released under [GPLv2](https://github.com/Champii/DexTop/blob/master/LICENSE.txt)

___
# Concept

DexTop is a cloud based desktop service. Its final goal is to provide to user the capacity to access and manage `every`  applications, from `any` of his machines, from `any` OS, and to `any`. At term, it will be OS agnostic, but for now, development is axed on X11 systems, usign `Xpra` server.

Actually it is exclusively turned to provide desktop based view, with complex windowing system.

A library to make clients for browsers is available here : [https://github.com/Champii/Xpra-html-client](https://github.com/Champii/Xpra-html-client) (under heavy development)

When more than on OS will be implemented, we can imagine a lot of interraction between differents windows from differents OSs (drag n drop, file sharing, clusturing, ...)
We can also imagine to implement this system on top of an existant cloud, with management of multiples virtual machines.

___
# Features

- Xpra (mono)server connexion
- Window shows up
- Windows content is drawn and refresh
- Drag n Drop

___
# Getting Started

You have to get the latest [Xpra-html-client](https://github.com/Champii/Xpra-html-client) library and put it in '/client/public/js/xpra'

Let's say you have a server headless where applications run, named 'runner'.

You have also a server to provide centralisation and serve browser application and content, named 'webserver'

And finaly a machine with a browser to test.

### Xpra Server (runner)

Check how to install xpra server: [http://xpra.org/](http://xpra.org/)

```
$> websockify  8080 localhost:10000&
$> xpra start :10 --bind-tcp=0.0.0.0:10000
```

Theses are default port values, and must be changed in the code for the moment

### Webserver
Then install npm packages and start web server:
```
$> npm install
$> npm install -g coffee-script
$> coffee main.coffee
```

Start a browser at 127.0.0.1:3000 (or whatever your webserver ip is)


___
# TODO

- Tray bar
- Server dynamic add
- 'start' menu
- window icons
- close, min/maximize
- tiling
- basic config
- auth
