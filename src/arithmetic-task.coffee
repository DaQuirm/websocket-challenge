class ArithmeticTask
  constructor: ->
    operators = ['+','-','*']

    @operands = [Math.round(Math.random()*9), Math.round(Math.random()*9)]
    @operator = operators[Math.floor Math.random()*operators.length]

  check: (result) ->
    [a,b] = @operands
    result is switch @operator
      when '+' then a + b
      when '-' then a - b
      when '*' then a * b

  messagify: ->
    msg: 'compute'
    operands: @operands
    operator: @operator

module.exports = ArithmeticTask
