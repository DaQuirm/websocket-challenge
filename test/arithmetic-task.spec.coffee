Chai = require 'chai'
Chai.should()

ArithmeticTask = require '../src/arithmetic-task.coffee'

describe 'Arithmetic Task', ->
	@arithmetic_task = null
	beforeEach =>
		@arithmetic_task = new ArithmeticTask
	
	describe 'operands property', =>
		it 'exist', =>
			@arithmetic_task.should.have.ownProperty 'operands'
		
		it 'is array', =>
			@arithmetic_task.operands.should.to.be.an 'array'
		
		it 'has two operands', =>
			@arithmetic_task.operands.should.not.be.empty
			@arithmetic_task.operands.should.have.length 2
		
		it 'has 0..9 for operands in container', =>
			@arithmetic_task.operands[0].should.be.within 0, 9
			@arithmetic_task.operands[1].should.be.within 0, 9
	
	describe 'operator property', =>
		it 'exist', =>
			@arithmetic_task.should.have.ownProperty 'operator'
		
		it 'is a string', =>
			@arithmetic_task.operator.should.be.a 'string'
		
		it 'has one operator from [+|-|*]', =>
			['+','-','*'].should.contain @arithmetic_task.operator
	
	describe 'check function', =>
		it 'exist', =>
			@arithmetic_task.check.should.be.a 'function'
		
		it 'returns boolean', =>
			@arithmetic_task.check().should.be.not.ok
		
		it 'checks result of calculation', =>
			[a, b] = @arithmetic_task.operands
			operator = @arithmetic_task.operator
			
			calculation = switch operator
				when '+' then a + b
				when '-' then a - b
				when '*' then a * b
			
			@arithmetic_task.check(calculation).should.be.ok
	
	describe 'messagify function', =>
		it 'exist', =>
			@arithmetic_task.messagify.should.be.a 'function'
		
		it 'returns object', =>
			@arithmetic_task.messagify().should.be.an 'object'
		
		it 'returns object with msg, operands and operator keys', =>
			@arithmetic_task.messagify().should.have.keys 'msg', 'operands', 'operator'
		
		it 'returns object with \'msg\' key with \'compute\' string', =>
			@arithmetic_task.messagify().msg.should.be.equal 'compute'
		
		it 'returns object with \'operator\' key with @operator', =>
			operator = @arithmetic_task.operator
			@arithmetic_task.messagify().operator.should.be.equal operator
		
		it 'returns object with \'operands\' key with @operands', =>
			operands = @arithmetic_task.operands
			@arithmetic_task.messagify().operands.should.be.equal operands
			