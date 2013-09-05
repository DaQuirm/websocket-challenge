[![Dependency Status](https://gemnasium.com/DaQuirm/websocket-challenge.png)](https://gemnasium.com/DaQuirm/websocket-challenge)

# Websocket Challenge

A simple WebSocket competition script for Node.js that
uses [WebSocket-Node](https://github.com/Worlize/WebSocket-Node) WebSocket server. The challenge is a little contest designed for after-training practice sessions so people can have fun with WebSockets applying their recently acquired knowledge.

## Installing and running
1. Run ```npm install websocket-challenge``` or clone this repo
2. Install dependencies with ```npm install```.
3. Install CoffeeScript if you don't have it: ```npm install -g coffee-script```
4. Run tests: ```npm test```
5. Run server: ```npm start```.

## Solving the challenge

WebSocket Challenge message protocol is JSON-based, `msg` field is used to determine message type.

````javascript
{ "msg":"message" }
````

Launch the server script.

Think of a cool team/participant name, establish a WebSocket connection and send a `challenge_accepted` message:
````javascript
{ "msg": "challenge_accepted", "name": "Socket Masters" }
````
The server will respond with
````javascript
{ "msg":"auth", "auth_token":"12a8d3c1" }
````
which contains an authentication token which you will attach to your messages so the server can identify your team. A very convenient way of WebSocket debugging is through WebSocket Frames panel in Network tab in Google Chrome developer tools.

There're just two simple tasks:

### Task #1

Request Task#1 with
````javascript
{ "msg": "task_one", "auth_token": token }
````
The server will respond with
````javascript
{ "msg": "compute", "operands":operands, "operator": operator };
````
where `operands` is a two-element array, e.g [3,7] of numbers no bigger than 9 and `operator` is a string `'+'` or `'*'` or `'-'` which corresponds to an arithmetic operation you have to perform with the operands. Send the result with
````javascript
{ "msg": "task_one_result", "result":10, "auth_token": token };
````
Response is either
````javascript
{ "msg": "win", "text": "" };
````
where `text` contains further instructions on how to request Task #2 (so people don't send Task #2 before Task #1) or an error message. All error messages have `msg` set to `"error"` so you can handle them separately or just use the WebSocket Frames panel.

### Task #2

When you find out how to request Task #2, the server will send you the following message:
````javascript
{ "msg": "binary_sum", "bits": 8 };
````
where bits is either 8 or 16. Immediately after that you should receive a binary message (16 bytes) which you should treat as a Uint8Array or Uint16Array depending on the `bits` field. Your task is to sum the resulting array's elements and send the result:

````javascript
{ "msg": "task_two_result", "auth_token": token, "result": 462374 }
````
After that you should receive a confirmation message (or an error message, which shouldn't make you sad, because you have unlimited attempts) which will end the challenge for you and, should you be the first to solve the tasks, declare you the winner (a message will appear in server console)!

That's all for now, there's plenty of room for improvement and extensions though, so your PRs are very welcome :wink:

## Contributors (in order of appearance)

[Vasiliy Ermolovich](http://github.com/nashby)  
[Dzmitry Varabei](http://github.com/dzmitry-varabei)  
[Pavel Nosovich](http://github.com/forcewake)
