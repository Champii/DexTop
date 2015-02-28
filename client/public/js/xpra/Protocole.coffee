class Protocole

  packets: {}
  handlers: {}

  constructor: (@ws) ->
    @ws.on 'message', =>
      if not @ws.rQwait "", 8, 0
        @ProcessBuffer()

  Send: (message...) ->
    bdata = bencode(message)

    cdata = []
    for i in [0...bdata.length]
      cdata.push(bdata[i].charCodeAt 0)
    level = 0

    len = cdata.length

    header = ["P".charCodeAt(0), 0, level, 0]
    for i in [3..0]
      header.push((len >> (8*i)) & 0xFF);

    header = header.concat(cdata);

    @ws.send(header);

  ProcessBuffer: ->
    header = @ws.rQpeekBytes 8

    if header[0] isnt "P".charCodeAt 0
      throw "invalid packet header format"

    if header[1]
      throw "we cannot handle any protocol flags yet, sorry"

    level = header[2];
    index = header[3];
    packet_size = 0;
    for i in [0...4]
      packet_size = packet_size*0x100;
      packet_size += header[4+i];

    if (@ws.rQlen() < packet_size-8)
      return;

    # packet is complete but header is still on buffer
    @ws.rQshiftBytes(8);
    packet_data = @ws.rQshiftBytes(packet_size);

    # decompress it if needed:
    if level
      inflated = new Zlib.Inflate(packet_data).decompress();
      packet_data = inflated;

    #save it for later? (partial raw packet)
    if index > 0
      @packets[index] = packet_data;
      return;

    #decode raw packet string into objects:
    packet = null;
    try
      packet = bdecode(packet_data);
      for index in @packets
        packet[index] = @packets[index];

      console.log packet
      @packets = {};
      @ProcessPacket(packet)
    catch e
      console.error("error processing packet: "+e);
      console.error("packet_data="+packet_data);

    # see if buffer still has unread packets
    if @ws.rQlen() > 8
      @ProcessBuffer()

  ProcessPacket: (packet) ->

    packet_type = "";
    fn = "";
    try
      packet_type = packet[0];
      # console.log("received a " + packet_type + " packet");

      fn = @handlers[packet_type];
      if (fn==undefined)
        console.error("no packet handler for "+packet_type+"!");
      else
        fn(packet);
    catch e
      console.error("error processing '"+packet_type+"' with '"+fn+"': "+e);
      throw e;
