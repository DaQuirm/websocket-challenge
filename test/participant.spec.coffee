Chai = requirChai = require 'chai'
Chai.should()

Participant = require '../src/participant.coffee'

describe 'Participant', ->
	participant = null
	name = 'test_name'
	connection = {}
	beforeEach ->
		participant = new Participant name, connection

	describe 'ctor', ->
		it 'throws exception `Participant\'s name can\'t be empty` when name is undefined', ->
			-> new Participant.should.throw 'Participant\'s name can\'t be empty'

	describe 'name', ->
		it 'exists', ->
			participant.should.have.ownProperty 'name'
		it 'is a string', ->
			participant.name.should.be.a 'string'

	describe 'state', ->
		it 'exists', ->
			participant.should.have.ownProperty 'state'
		it 'is a string', ->
			participant.state.should.be.a 'string'

	describe 'auth_token', ->
		it 'exists', ->
			participant.should.have.ownProperty 'auth_token'
		it 'is a string', ->
			participant.auth_token.should.be.a 'string'
		it 'has length 8', ->	
			participant.auth_token.should.have.length 8
		it 'is different for every `Participant` instance', ->
			first_token = participant.auth_token
			name = 'second_name'
			participant = new Participant name, connection
			participant.auth_token.should.not.equal first_token

	describe 'get_token_message', ->
		it 'exists', ->
			participant.get_token_message.should.be.a 'function'
		it 'returns an object', ->
			participant.get_token_message().should.be.an 'object'
		it 'returns an object with \'msg\' and \'auth_token\' keys', ->
			participant.get_token_message().should.have.keys 'msg', 'auth_token'
		it 'returns an object with \'msg\' key with \'auth\' string', ->
			participant.get_token_message().msg.should.equal 'auth'
		it 'returns an object with \'auth_token\' key with auth_token value', ->
			auth_token = participant.auth_token
			participant.get_token_message().auth_token.should.equal auth_token

	describe 'assign_task', ->
		it 'exists', ->
			participant.assign_task.should.be.a 'function'
		it 'returns an object', ->
			participant.assign_task({},{}).should.be.an 'object'
		it 'assign a task to the participant and returns tasks', ->
			task_name = 'task_name'
			task_data = name: 'task_data'
			participant.assign_task(task_name, task_data).should.equal task_data
		it 'makes it possible to assign more than one task to the participant', ->
			first_task_name = 'first_task_name'
			first_task_data = name: 'first_task_data'	
			second_task_name = 'second_task_name'
			second_task_data = name: 'second_task_data'
			participant.assign_task first_task_name, first_task_data
			participant.assign_task second_task_name, second_task_data
			participant.tasks.should.not.be.empty
			participant.tasks.should.contain.keys first_task_name, second_task_name
			participant.tasks.first_task_name.should.equal first_task_data
			participant.tasks.second_task_name.should.equal second_task_data

	describe 'check_task', ->
		it 'exists', ->
			participant.check_task.should.be.a 'function'
		it 'throws an error exception when task is not assing to the participant', ->
			-> participant.check_task().should.throw Error
		it 'returns a boolean', ->
			first_task_name = 'first_task_name'
			first_task_data = check: -> return true
			participant.assign_task first_task_name, first_task_data
			participant.check_task(first_task_name).should.be.a 'boolean'
		it 'checks result for tasks', ->
			first_task_name = 'first_task_name'
			first_task_data = check: -> true
			participant.assign_task first_task_name, first_task_data
			participant.check_task(first_task_name).should.be.ok

	describe 'update_state', ->
		it 'throw an error exception when argument is not a string', ->
			-> participant.update_state(state:'new').should.throw Error
			-> participant.update_state().should.throw Error
		it 'update current participant`s state', ->
			state = 'new'
			participant.update_state(state)
			participant.state.should.be.equal state
