http = require 'http'
bunyan = require 'bunyan'
WebSocketServer = require('websocket').server

Protocol = require './protocol.coffee'
Participant = require './participant.coffee'
ArithmeticTask = require './arithmetic-task.coffee'
BinaryTask = require './binary-task.coffee'

class Challenge
  constructor: ->
    # participants by their auth_token
    @participants = {}

  add_participant: (participant) ->
    @participants[participant.auth_token] = participant

  get_participant: (auth_token) ->
    if auth_token of @participants
      @participants[auth_token]
    else
      throw new Error 'Token is invalid'

  respond: (connection, response_data) ->
    toBuffer = (ab) ->
      buffer = new Buffer ab.byteLength
      view = new Uint8Array ab
      for i in [0...buffer.length]
        buffer[i] = view[i]
      buffer

    process = (data) ->
      if data instanceof ArrayBuffer
        connection.sendBytes toBuffer(data)
      else
        connection.sendUTF JSON.stringify(data)

    if Array.isArray response_data
      response_data.forEach process
    else
      process response_data

  start: ->
    @http_server = http.createServer (request, response) ->
      console.log "#{new Date} Received request for #{request.url}"
      response.writeHead 404
      do response.end

    @http_server.listen 8080, ->
      console.log "#{new Date} HTTP server is listening on port 8080"

    @websocket_server = new WebSocketServer
      httpServer: @http_server

    @log = bunyan.createLogger
      name:'challenge'
      streams: [
          level: 'info'
          path: 'challenge.json'
      ]

    @websocket_server.on 'request', (request) =>
      connection = request.accept '', request.origin

      @protocol = new Protocol
        'challenge_accepted': (message) =>
          participant = new Participant message.name, connection
          @add_participant participant
          do participant.get_token_message

        'task_one': (message) =>
          participant = @get_participant message.auth_token
          task = participant.assign_task 'task_one', new ArithmeticTask
          do task.messagify

        'task_one_result': (message) =>
          participant = @get_participant message.auth_token
          if participant.check_task('task_one', message.result)
            msg: 'win'
            text: 'Awesome! now send msg:\'next\' for task #2!'
          else
            throw new Error 'Wrong result :('

        'next': (message) =>
          participant = @get_participant message.auth_token
          task = participant.assign_task 'task_two', new BinaryTask
          do task.messagify

        'task_two_result': (message) =>
          participant = @get_participant message.auth_token
          if participant.check_task('task_two', message.result)
            msg: 'epic_win'
            text: 'EPIC WIN! You have completed the challenge!'
            code: 6455
          else
            throw new Error 'Wrong result :('

      # `auth_token` is obligatory
      @protocol.secure_messages =
        'task_one': true
        'task_one_result': true
        'next': true
        'task_two_result': true

      # `result` field is obligatory
      @protocol.result_messages =
        'task_one_result': true
        'task_two_result': true

      connection.on 'message', (message) =>
        try
          response_data = @protocol.process message
          @respond connection, response_data if response_data
          @log.info message, 'received'
          @log.info response_data, 'response'
        catch ex
          connection.sendUTF @protocol.create_error_msg ex.message
          @log.error ex, 'error'

module.exports = Challenge
