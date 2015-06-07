_ = require 'lodash'
ProtoBuf = require 'protobufjs'

class MicrobluTransformer
  constructor: (opts={}) ->
    @path = opts.path || __dirname + '/microblu.proto'
    @format = opts.format || 'base64'

    builder = ProtoBuf.loadProtoFile @path
    @MicrobluProto = builder.build 'MicrobluState'

  toProtocolBuffer: (msg, callback=->) =>
    msgProto = new @MicrobluProto msg
    msgProto.encode()

    return callback null, msgProto.toBuffer() if opts.format == 'binary'
    callback null, msgProto.toBuffer().toString @format

  toJSON: (msg, callback) =>

    if typeof msg == 'string'
      msgBuffer = new Buffer msg, @format
    else
      msgBuffer = new Buffer msg

    msgProto = @MicrobluProto.decode msgBuffer

    callback null, JSON.parse msgProto.encodeJSON()


module.exports = MicrobluTransformer
