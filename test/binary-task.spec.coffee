Chai = require 'chai'
Chai.should()

BinaryTask = require '../src/binary-task.coffee'

describe 'Binary task', ->
	binary_task = null

	it 'should have a bits property', ->
		binary_task = new BinaryTask
		binary_task.should.have.ownProperty 'bits'

	it 'should have a buffer property', ->
		binary_task = new BinaryTask
		binary_task.should.have.ownProperty 'buffer'

	it 'should have a arrays property', ->
		binary_task = new BinaryTask
		binary_task.should.have.ownProperty 'arrays'

	it 'should have a arrays property as object', ->
		binary_task = new BinaryTask
		binary_task.arrays.should.be.an 'object'

	it 'should have a check function', ->
		binary_task = new BinaryTask
		binary_task.check.should.be.a 'function'

	it 'check function should return boolean', ->
		binary_task = new BinaryTask
		binary_task.check().should.be.not.ok

	it 'check function should check sum for elements in buffer', ->
		binary_task = new BinaryTask

		bits = binary_task.bits
		buffer = binary_task.buffer
		arrays = binary_task.arrays

		arr = new arrays[bits] buffer
		sum = 0
		for i in [0...arr.length]
			sum += arr[i]

		binary_task.check(sum).should.be.ok

	it 'should have a messagify function', ->
		binary_task = new BinaryTask
		binary_task.messagify.should.be.a 'function'

	it 'messagify function should return array', ->
		binary_task = new BinaryTask
		binary_task.messagify().should.be.a 'array'

	it 'messagify function should return array with two elements', ->
		binary_task = new BinaryTask
		binary_task.messagify().should.have.length 2

	it 'messagify function should return array with two elements 
where first element should be a object', ->
		binary_task = new BinaryTask
		binary_task.messagify()[0].should.be.a 'object'

	it 'messagify function should return array with two elements 
where first element should be a object with msg and bit keys', ->
		binary_task = new BinaryTask
		binary_task.messagify()[0].should.have.keys 'msg', 'bits'

	it 'messagify function should return array with two elements 
where first element should be a object with msg and bit keys, 
where msg key is equal to \'binary_sum\'', ->
		binary_task = new BinaryTask
		binary_task.messagify()[0].msg.should.be.equal 'binary_sum'

	it "messagify function should return array with two elements 
where first element should be a object with msg and bit keys, 
where msg key is equal to \'binary_sum\' and bits should be 
equal @bits property", ->
		binary_task = new BinaryTask

		bits = binary_task.bits
		binary_task.messagify()[0].bits.should.be.equal bits

	it 'messagify function should return array where second element
is ArrayBuffer object equal to @buffer', ->
		binary_task = new BinaryTask

		buffer = binary_task.buffer
		binary_task.messagify()[1].should.be.equal buffer

