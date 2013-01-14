class BinaryTask
  constructor: ->
    @buffer = new ArrayBuffer 16
    bitsValues = [8, 16]
    @bits = bitsValues[Math.round(Math.random()*1000) % 2]
    @arrays =
      8: Uint8Array
      16: Uint16Array

    arr = new @arrays[@bits] @buffer
    for i in [0...16 / (@bits / 8)]
      arr[i] = Math.round Math.random()*Math.pow(2,@bits)

  check: (result)->
    arr = new @arrays[@bits] @buffer
    sum = 0
    for i in [0...arr.length]
      sum += arr[i]
    sum is result

  messagify: ->
    [
      msg: 'binary_sum'
      bits: @bits,

      @buffer
    ]

module.exports = BinaryTask
