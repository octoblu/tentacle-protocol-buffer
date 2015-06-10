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
    msgProto = new @MicrobluProto msg
    #console.log "msg is: #{JSON.stringify(msgProto)}"
    #console.log "incoming message is: #{JSON.stringify(msg, null, 2)}"
    _.each _.keysIn(@msgProto), (key) =>
      console.log "message has key: #{key}"
    msgProto.encode()
    return Buffer.concat [msgProto.toBuffer(), new Buffer([0])]

  addData: (data) =>
    console.log "adding data"
    return unless data
    @buffer = ByteBuffer.concat [@buffer, ByteBuffer.wrap(data)]

  toJSON: () =>
    return unless @buffer?.remaining() > 0
    decoded = @MicrobluProto.decode @buffer
    return null if !decoded
    @buffer.compact()
    return JSON.parse decoded.encodeJSON()

module.exports = TentacleTransformer
