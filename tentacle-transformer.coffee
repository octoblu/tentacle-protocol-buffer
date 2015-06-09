_ = require 'lodash'
ProtoBuf = require 'protobufjs'
ByteBuffer = require 'bytebuffer'

class TentacleTransformer
  constructor: (opts={}) ->
    @buffer = new Buffer 0
    @path = opts.path || __dirname + '/tentacle-message.proto'
    @messageType = opts.message || 'TentacleMessage'

    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build @messageType

  toProtocolBuffer: (msg) =>
    msgProto = new @MicrobluProto msg
    msgProto.encodeDelimited()
    msgProto.toBuffer()

  addData: (data) =>
    @buffer = Buffer.concat([@buffer, data])

  toJSON: () =>
    return null unless @buffer.length

    try
      decoded = @MicrobluProto.decodeDelimited @buffer
      return null if !decoded
      result = JSON.parse decoded.encodeJSON()
      size = ByteBuffer.wrap(@buffer).readVarint32()
      console.error 'my size is', size
      @buffer = @buffer.slice(size, @buffer.length)
      return result

    catch error
      console.log('transformer error:',error.message)
      return null

module.exports = TentacleTransformer
