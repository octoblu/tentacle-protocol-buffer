_ = require 'lodash'
ProtoBuf = require 'protobufjs'
ByteBuffer = ProtoBuf.ByteBuffer

class TentacleTransformer
  constructor: (opts={}) ->
    @path = opts.path || __dirname + '/tentacle-message.proto'
    @messageType = opts.message || 'TentacleMessage'

    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build @messageType

  toProtocolBuffer: (msg) =>
    msgProto = new @MicrobluProto msg
    msgProto.encodeDelimited()
    msgProto.toBuffer()

  addData: (data) =>
    console.log "adding data"
    return unless data

    if !@buffer
      @buffer = ByteBuffer.wrap(data)
    else
      @buffer = ByteBuffer.concat [@buffer, ByteBuffer.wrap(data)]

  toJSON: () =>
    return unless @buffer?.remaining() > 0
    
    try
      decoded = @MicrobluProto.decodeDelimited @buffer
      return null if !decoded
      @buffer.compact()

      return JSON.parse decoded.encodeJSON()

    catch error
      console.log('transformer error:',error.message)
      return null

module.exports = TentacleTransformer
