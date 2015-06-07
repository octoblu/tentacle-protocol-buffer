_ = require 'lodash'
ProtoBuf = require 'protobufjs'

class MicrobluTransformer
  constructor: (opts={}) ->
    @path = opts.path || 'microblu.proto'
    @format = opts.format || 'base64'

  initialize: =>
    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build 'Microblu'

  toProtocolBuffer: (msg, callback=->) =>
    msgProto = new @MicrobluProto msg
    msgProto.encode()
    callback null, msgProto.toBuffer().toString @format

  toJson: (msg, callback) =>
    msgBuffer = new Buffer msg, @format
    msgProto = @MicrobluProto.decode msgBuffer

    callback null, JSON.parse msgProto.encodeJSON()


module.exports = MicrobluTransformer
