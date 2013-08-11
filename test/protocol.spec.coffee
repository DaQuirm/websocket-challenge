Chai = require 'chai'
Chai.should()

Protocol = require '../src/protocol.coffee'

describe 'Protocol', ->
	actions = null
	protocol = null
	beforeEach ->
		protocol = new Protocol actions

	describe 'has_result', ->
		it 'exists', ->
			protocol.has_result.should.be.a 'function'

		it 'checks result for the task', ->
			utf8Data = 
				msg: 'task'
				result: true
			message = utf8Data: JSON.stringify utf8Data
			actions = task: -> true
			protocol = new Protocol actions
			protocol.process message
			protocol.has_result().should.be.ok
	
	describe 'is_secure', ->
		it 'exists', ->
			protocol.is_secure.should.be.a 'function'

		it 'checks if the message has auth_token', ->
			utf8Data = 
				msg: 'task'
				auth_token: true
			message = utf8Data: JSON.stringify utf8Data
			actions = task: -> true
			protocol = new Protocol actions
			protocol.process message
			protocol.is_secure().should.be.ok

	describe 'create_error_msg', ->
		it 'exists', ->
			protocol.create_error_msg.should.be.a 'function'

		it 'returns a string', ->
			protocol.create_error_msg().should.be.a 'string'

		it 'creates a string with the error message', ->
			message = 'error_message'
			error_message = JSON.stringify
				msg: 'error'
				text: message
			protocol.create_error_msg(message).should.equal error_message

	describe 'process', ->
		it 'exists', ->
			protocol.process.should.be.a 'function'

		it 'throws exception `Invalid JSON :(` if message is not JSON', ->
			message = {}
			-> protocol.process(message).show.throw '`Invalid JSON :('

		it 'parses JSON from message.utf8data', ->
			utf8Data = msg: 'task'
			message = utf8Data: JSON.stringify utf8Data
			actions = task: -> true
			protocol = new Protocol actions
			protocol.process(message).should.be.ok

		it 'throws exception `Message can\'t be sent without an auth token if message should contains `auth_token`', ->
			protocol.secure_messages = task: true
			utf8Data = msg: 'task'
			message = utf8Data: JSON.stringify utf8Data
			-> protocol.process(message).should.throw 'Message `#{@utf8Data.msg}` can\'t be sent without an auth token'

		it 'throws exception `Message must have a `result` field` if message should contains `result` field', ->
			protocol.result_messages = task: true
			utf8Data = msg: 'task'
			message = utf8Data: JSON.stringify utf8Data
			-> protocol.process(message).should.throw 'Message `#{@utf8Data.msg}` must have a `result` field'
