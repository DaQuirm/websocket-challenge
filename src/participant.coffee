crypto = require 'crypto'

class Participant

	constructor: (@name, @connection) ->
		throw new Error 'Participant\'s name can\'t be empty' unless @name
		@auth_token = crypto.randomBytes(4).toString 'hex'
		@tasks = {}
		@state = ''

	assign_task: (name, task) ->
		@tasks[name] = task

	check_task: (name, result) ->
		throw new Error "Can't check task #{name}: it's not assigned" unless @tasks[name]
		@tasks[name].check result

	get_token_message: ->
		msg: 'auth'
		auth_token: @auth_token

	update_state: (state) ->
		throw new Error 'Participant\'s state can\'t be empty' unless state
		throw new Error 'Participant\'s state must be a string' unless typeof state is 'string'
		@state = state

module.exports = Participant
