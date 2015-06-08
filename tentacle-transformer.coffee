_ = require 'lodash'
ProtoBuf = require 'protobufjs'

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
      @buffer = @buffer.slice(decoded.calculate()+1, @buffer.length)
      result = JSON.parse decoded.encodeJSON()
      return result

    catch error
      console.log('transformer error:',error.message)
      return null

module.exports = TentacleTransformer
