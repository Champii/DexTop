### Copyright (c) 2009 Anton Ekblad
# Copyright (c) 2013 Antoine Martin <antoine@devloop.org.uk>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
###

###
# This is a modified version, suitable for xpra wire encoding:
# - the input must be a buffer (a byte array or native JS array)
# - we do not sort lists or dictionaries (the existing order is preserved)
# - error out instead of writing "null" and generating a broken stream
# - handle booleans as ints (0, 1)
###

# bencode an object

bencode = (obj) ->
  if obj is null or obj is undefined
    throw 'invalid: cannot encode null'
  switch btypeof(obj)
    when 'string'
      return bstring(obj)
    when 'number'
      return bint(obj)
    when 'list'
      return blist(obj)
    when 'dictionary'
      return bdict(obj)
    when 'boolean'
      return bint(if obj then 1 else 0)
    else
      throw 'invalid object type in source: ' + btypeof(obj)
  return

# decode a bencoded string into a javascript object

bdecode = (buf) ->
  dec = bparse(buf)
  if dec != null and dec[1].length is 0
    return dec[0]
  null

# parse a bencoded string; bdecode is really just a wrapper for this one.
# all bparse* functions return an array in the form
# [parsed object, remaining buffer to parse]

bparse = (buf) ->
  if buf.subarray
    switch buf[0]
      when ord('d')
        return bparseDict(buf.subarray(1))
      when ord('l')
        return bparseList(buf.subarray(1))
      when ord('i')
        return bparseInt(buf.subarray(1))
      else
        return bparseString(buf)
  else
    #assume normal js array and use slice
    switch buf[0]
      when ord('d')
        return bparseDict(buf.slice(1))
      when ord('l')
        return bparseList(buf.slice(1))
      when ord('i')
        return bparseInt(buf.slice(1))
      else
        return bparseString(buf)
  return

uintToString = (uintArray) ->
  String.fromCharCode.apply null, uintArray

# javascript equivallent of ord()
# returns the numeric value of the character

ord = (c) ->
  c.charCodeAt 0

# returns the part of the buffer
# before character c

subto = (buf, c) ->
  i = 0
  o = ord(c)
  while buf[i] != o
    if i >= buf.length
      return buf
    i++
  if buf.subarray
    buf.subarray 0, i
  else
    buf.slice 0, i

# splits the buffer into two parts:
# before and after the first occurrence of c

split1 = (buf, c) ->
  i = 0
  o = ord(c)
  while buf[i] != o
    if i >= buf.length
      return [ buf ]
    i++
  if buf.subarray
    [
      buf.subarray(0, i)
      buf.subarray(i + 1)
    ]
  else
    [
      buf.slice(0, i)
      buf.slice(i + 1)
    ]

# parse a bencoded string

bparseString = (buf) ->
  `var r`
  `var str`
  len = 0
  buf2 = subto(buf, ':')
  if isNum(buf2)
    len = parseInt(uintToString(buf2))
    if buf.subarray
      str = buf.subarray(buf2.length + 1, buf2.length + 1 + len)
      r = buf.subarray(buf2.length + 1 + len)
    else
      str = buf.slice(buf2.length + 1, buf2.length + 1 + len)
      r = buf.slice(buf2.length + 1 + len)
    return [
      uintToString(str)
      r
    ]
  null

# parse a bencoded integer

bparseInt = (buf) ->
  buf2 = subto(buf, 'e')
  if !isNum(buf2)
    return null
  if buf.subarray
    [
      parseInt(uintToString(buf2))
      buf.subarray(buf2.length + 1)
    ]
  else
    [
      parseInt(uintToString(buf2))
      buf.slice(buf2.length + 1)
    ]

# parse a bencoded list

bparseList = (buf) ->
  p = undefined
  list = []
  e = ord('e')
  while buf[0] != e and buf.length > 0
    p = bparse(buf)
    if null is p
      return null
    list.push p[0]
    buf = p[1]
  if buf.length <= 0
    console.log 'unexpected end of buffer reading list'
    return null
  if buf.subarray
    [
      list
      buf.subarray(1)
    ]
  else
    [
      list
      buf.slice(1)
    ]

# parse a bencoded dictionary

bparseDict = (buf) ->
  key = undefined
  val = undefined
  dict = {}
  e = ord('e')
  while buf[0] != e and buf.length > 0
    key = bparse(buf)
    if null is key
      return
    val = bparse(key[1])
    if null is val
      return null
    dict[key[0]] = val[0]
    buf = val[1]
  if buf.length <= 0
    return null
  if buf.subarray
    [
      dict
      buf.subarray(1)
    ]
  else
    [
      dict
      buf.slice(1)
    ]

# is the given string numeric?

isNum = (buf) ->
  i = undefined
  c = undefined
  if buf.length is 0
    return false
  if buf[0] is ord('-')
    i = 1
  else
    i = 0
  while i < buf.length
    c = buf[i]
    if c < 48 or c > 57
      return false
    i++
  true

# returns the bencoding type of the given object

btypeof = (obj) ->
  type = typeof obj
  if type is 'object'
    if typeof obj.length is 'undefined'
      return 'dictionary'
    return 'list'
  type

# bencode a string

bstring = (str) ->
  str.length + ':' + str

# bencode an integer

bint = (num) ->
  'i' + num + 'e'

# bencode a list

blist = (list) ->
  str = undefined
  str = 'l'
  for key of list
    `key = key`
    str += bencode(list[key])
  str + 'e'

# bencode a dictionary

bdict = (dict) ->
  str = undefined
  str = 'd'
  for key of dict
    `key = key`
    str += bencode(key) + bencode(dict[key])
  str + 'e'
