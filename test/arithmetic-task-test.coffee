Chai = require 'chai'
Chai.should()

ArithmeticTask = require '../src/arithmetic-task.coffee'

describe 'Arithmetic task', ->
	arithmetic_task = null

	it 'should have a container for operands', ->
		arithmetic_task = new ArithmeticTask
		arithmetic_task.operands.should.to.be.an 'array'

	it 'should have 2 operands in container', ->
		arithmetic_task = new ArithmeticTask
		arithmetic_task.operands.should.to.be.not.empty
		arithmetic_task.operands.should.have.length 2

	it 'should have 0..9 for operands in container', ->
		arithmetic_task = new ArithmeticTask
		arithmetic_task.operands[0].should.within 0, 9
		arithmetic_task.operands[1].should.within 0, 9

	it 'should have one operator', ->
		arithmetic_task = new ArithmeticTask
		arithmetic_task.operator.should.be.a 'string'
		['+','-','*'].should.contain arithmetic_task.operator

	it 'should have a check method for calculation', ->
		arithmetic_task = new ArithmeticTask
		[a, b] = arithmetic_task.operands
		operator = arithmetic_task.operator

		calculation = switch operator
			when '+' then a + b
			when '-' then a - b
			when '*' then a * b
		
		arithmetic_task.check.should.be.a 'function'
		arithmetic_task.check(calculation).should.be.a 'boolean'
		arithmetic_task.check(calculation).should.be.ok

	it 'should have a messagify method', ->
		arithmetic_task = new ArithmeticTask

		operands = arithmetic_task.operands
		operator = arithmetic_task.operator

		arithmetic_task.messagify.should.be.a 'function'
		arithmetic_task.messagify().should.be.a 'object'
		arithmetic_task.messagify().should.have.keys 'msg', 'operands', 'operator'
		arithmetic_task.messagify().msg.should.be.equal 'compute'
		arithmetic_task.messagify().operator.should.be.equal operator
		arithmetic_task.messagify().operands.should.be.equal operands