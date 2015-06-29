_ = require 'lodash'
ProtoBuf = require 'protobufjs'
ByteBuffer = ProtoBuf.ByteBuffer

class TentacleTransformer
  constructor: (opts={}) ->
    @path = opts.path || __dirname + '/tentacle-message.proto'
    @messageType = opts.message || 'TentacleMessage'
    @buffer = ByteBuffer.wrap new Buffer(0)
    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build @messageType

  toProtocolBuffer: (msg) =>
    buffer = new ByteBuffer()
    msgProto = new @MicrobluProto msg
    msgProto.encodeDelimited buffer
    buffer.flip()
    buffer.toBuffer()

  addData: (data) =>
    console.log "adding data"
    return unless data
    @buffer = ByteBuffer.concat [@buffer, ByteBuffer.wrap(data)]

  toJSON: () =>
    return null unless @buffer?.remaining() > 0
    decoded = @MicrobluProto.decodeDelimited @buffer
    return null if !decoded
    @buffer.compact()
    return JSON.parse decoded.encodeJSON()

module.exports = TentacleTransformer
