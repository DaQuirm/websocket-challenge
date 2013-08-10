class Protocol
  constructor: (@actions) ->
    @secure_messages = {}
    @result_messages = {}

  process: (message) ->
    try
      @json = JSON.parse message.utf8Data
    catch ex
      throw new Error 'Invalid JSON :('

    if @json.msg of @secure_messages
      unless @is_secure()
        throw new Error "Message `#{@json.msg}` can't be sent without an auth token"

    if @json.msg of @result_messages
      unless @has_result()
        throw new Error "Message `#{@json.msg}` must have a `result` field"

    if @json.msg of @actions
      @actions[@json.msg] @json

  create_error_msg: (error_text) ->
    JSON.stringify
      msg: 'error'
      text: error_text

  is_secure: ->
    @json.auth_token?

  has_result: ->
    @json.result?

module.exports = Protocol
