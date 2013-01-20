crypto = require 'crypto'

class Participant

  constructor: (@name, @connection) ->
  	throw new Error "Participant's name can't be empty" unless @name
  	@auth_token = crypto.randomBytes(4).toString 'hex'
  	@tasks = {}

  assign_task: (name, task) ->
  	@tasks[name] = task

  check_task: (name, result) ->
  	throw new Error "Can't check task #{name}: it's not assigned" unless @tasks[name]
  	@tasks[name].check result

  get_token_message: ->
  	msg: 'auth'
  	auth_token: @auth_token

module.exports = Participant
