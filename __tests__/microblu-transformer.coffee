jest.autoMockOff()
MicrobluTransformer = require '../microblu-transformer'

describe 'MicrobluTransformer', ->
  beforeEach ->
    @sut = new MicrobluTransformer
    @sut.initialize()
  it 'should instantiate', ->
    expect(@sut).toBeDefined()

  it 'should set it\'s path to "microblu.proto" by default', ->
    expect(@sut.path).toBe 'microblu.proto'

  describe '->initialize()', ->
    it 'sounds like a 2-stage constructor', ->
      expect(@sut.initialize).toBeDefined()

  describe '->toProtocolBuffer()', ->
    describe 'when called with valid microblu JSON', ->
      beforeEach ->
        @callback = jest.genMockFunction()
        @sut.toProtocolBuffer(
          topic: 'digitalRead'
          payload:
            pin: 7
          @callback
        )

      it 'should call the callback with a value', ->
        expect(@callback.mock.calls[0][1]).toBeDefined()

    describe '->toJson', ->
      describe 'when called with a protocol buffer', ->
        beforeEach ->
          @sut.toProtocolBuffer(
            topic: 'digitalWrite'
            payload:
              pin: 17
              value: '1'
            (error, @msgProto) =>
          )
          @sut.toJson @msgProto, (error, @msgJson) =>

        it 'should have the same value as the data going in to it', ->
          expect(@msgJson).toEqual
            topic: 'digitalWrite'
            payload:
              pin: 17
              value: '1'
