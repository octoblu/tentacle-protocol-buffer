jest.autoMockOff()
MicrobluTransformer = require '../microblu-transformer'

describe 'MicrobluTransformer', ->
  beforeEach ->
    @sut = new MicrobluTransformer
  it 'should instantiate', ->
    expect(@sut).toBeDefined()

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

    describe '->toJSON', ->
      describe 'when called with a protocol buffer', ->
        beforeEach ->
          @sut.toProtocolBuffer(
            topic: 'digitalWrite'
            payload:
              pin: 17
              value: '1'
            (error, @msgProto) =>
          )
          @sut.toJSON @msgProto, (error, @msgJson) =>

        it 'should have the same value as the data going in to it', ->
          expect(@msgJson).toEqual
            topic: 'digitalWrite'
            payload:
              pin: 17
              value: '1'
