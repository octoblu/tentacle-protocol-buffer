_ = require 'lodash'
ProtoBuf = require 'protobufjs'
ByteBuffer = ProtoBuf.ByteBuffer

class TentacleTransformer
  constructor: (opts={}) ->
    @path = opts.path || __dirname + '/tentacle-message.proto'
    @messageType = opts.message || 'TentacleMessage'
    @buffer = ByteBuffer.wrap(new Buffer(0))
    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build @messageType

  toProtocolBuffer: (msg) =>
    buffer = new ByteBuffer()
    msgProto = new @MicrobluProto msg
    msgProto.encodeDelimited buffer
    buffer.flip()
    console.log 'message of length', buffer.buffer.length, 'with head of', buffer.readVarint32(), 'and first byte', buffer.buffer[0]
    byteString = ""
    for num in [0..buffer.buffer.length-1]
      byteString += buffer.readInt8(num).toString(16).toUpperCase()
    console.log 'look at my string, it tastes like lemonade'
    console.log byteString
    buffer.buffer
    #return buffer.buffer

    #console.log "msg is: #{JSON.stringify(msgProto)}"
    #console.log "incoming message is: #{JSON.stringify(msg, null, 2)}"
    # wut = new ByteBuffer(0)
    # wut = msgProto.encodeDelimited(wut)
    # #return Buffer.concat [msgProto.toBuffer(), new Buffer([0])]
    # buf = msgProto.toBuffer()
    # console.log 'backing buffer is of length', wut.buffer.length, wut.buffer[0]
    # console.log 'header says I have', wut.readVarint32(0)
    # console.log 'testing first char', buf[0]
    # console.log 'message to device has length', buf.length
    # lenBuf = new ByteBuffer(4)
    # newBuf.writeVarint32(buf.length,0)
    #
    # return

  addData: (data) =>
    console.log "adding data"
    return unless data
    @buffer = ByteBuffer.concat [@buffer, ByteBuffer.wrap(data)]

  toJSON: () =>
    return unless @buffer?.remaining() > 0
    decoded = @MicrobluProto.decodeDelimited @buffer
    return null if !decoded
    @buffer.compact()
    return JSON.parse decoded.encodeJSON()

module.exports = TentacleTransformer
