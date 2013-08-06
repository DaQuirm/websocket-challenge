Chai = requirChai = require 'chai'
Chai.should()

BinaryTask = require '../src/binary-task.coffee'

describe 'BinaryTask', ->
	binary_task = null
	beforeEach ->
		binary_task = new BinaryTask

	describe 'bit', ->
		it 'exists', ->
			binary_task.should.have.ownProperty 'bits'

	describe 'buffer', ->
		it 'exists', ->
			binary_task.should.have.ownProperty 'bits'

	describe 'arrays', ->
		it 'exists', ->
			binary_task.should.have.ownProperty 'arrays'

	describe 'check', ->
		it 'exists', ->
			binary_task.check.should.be.a 'function'

		it 'returns a boolean', ->
			binary_task.check().should.not.be.ok

		it 'checks sum for elements in buffer', ->
			bits = binary_task.bits
			buffer = binary_task.buffer
			arrays = binary_task.arrays

			arr = new arrays[bits] buffer
			sum = 0
			for i in [0...arr.length]
				sum += arr[i]

			binary_task.check(sum).should.be.ok

	describe 'messagify', ->
		it 'exists', ->
			binary_task.messagify.should.be.a 'function'

		it 'returns an array', ->
			binary_task.messagify().should.be.an 'array'

		it 'returns an array with two elements', ->
			binary_task.messagify().should.have.length 2

		it 'returns an array with two elements where first element is an object', ->
			binary_task.messagify()[0].should.be.an 'object'

		it 'returns an array with two elements where first element is an object with msg and bit keys', ->
			binary_task.messagify()[0].should.have.keys 'msg', 'bits'

		it 'returns an array with two elements where first element is an object with msg and bit keys, where msg key is equal to \'binary_sum\'', ->
			binary_task.messagify()[0].msg.should.equal 'binary_sum'

		it 'returns an array with two elements where first element is an object with msg and bit keys, where msg key is equal to \'binary_sum\'', ->
			bits = binary_task.bits
			binary_task.messagify()[0].bits.should.equal bits

		it 'returns an array where second element is ArrayBuffer object equal buffer', ->
			buffer = binary_task.buffer
			binary_task.messagify()[1].should.equal buffer
