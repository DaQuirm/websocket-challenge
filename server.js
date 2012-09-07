var WebSocketServer = require('websocket').server;
var http = require('http');

var server = http.createServer(function(request, response) {
    console.log((new Date()) + ' Received request for ' + request.url);

    response.writeHead(404);
    response.end();
});

server.listen(8080, function() {
    console.log((new Date()) + ' Server is listening on port 8080');
});

wsServer = new WebSocketServer({
    httpServer: server
});

var teams = {};

var issueToken = function() {
    return (new Date()).getTime().toString(16) + Math.round(Math.random()*0xf).toString(16);
};

var addTeam = function(name, connection) {
    var token = issueToken();
    teams[token] = {
        name: name,
        connection: connection
    };
    return token;
};

var generateTask1 = function() {
    var operators = ['+','-','*'];
    var operands = [Math.round(Math.random()*9), Math.round(Math.random()*9)];

    return {
        msg: "compute",
        operands:operands,
        operator: operators[Math.round(Math.random()*1000) % 3]
    };
};

var computeTask1 = function(task) {
    var result;
    switch (task.operator) {
        case '+':
            result = task.operands[0] + task.operands[1];
            break;
        case '-':
            result = task.operands[0] - task.operands[1];
            break;
        case '*':
            result = task.operands[0] * task.operands[1];
            break;
    }
    return result;
};

var generateTask2 = function() {
    var buffer = new ArrayBuffer(16);
    var bitsValues = [8, 16];
    var bits = bitsValues[Math.round(Math.random()*1000) % 2];
    var arrs = {
        8: Uint8Array,
        16: Uint16Array,
    }
    var arr = new arrs[bits](buffer);
    for (var i = 0; i < 16 / (bits / 8); i++) {
        arr[i] = Math.round(Math.random()*Math.pow(2,bits));
    }
    return [
        { msg: "sum", bits:bits },
        buffer
    ];
};

var computeTask2 = function(task) {
    var result;
    var arrs = {
        8: Uint8Array,
        16: Uint16Array,
    }
    var arr = new arrs[task[0].bits](task[1]);
    var sum = 0;
    for (var i = 0; i < arr.length; i++) {
        sum += arr[i];
    }
    result = sum;
    return result;
};

function toBuffer(ab) {
    var buffer = new Buffer(ab.byteLength);
    var view = new Uint8Array(ab);
    for (var i = 0; i < buffer.length; ++i) {
        buffer[i] = view[i];
    }
    return buffer;
}

var winner = null;

wsServer.on('request', function(request) {
    var connection = request.accept('', request.origin);
    console.log((new Date()) + ' Connection accepted.');
    connection.on('message', function(message) {

        if (message.type === 'utf8') {
            console.log('Received Message: ' + message.utf8Data);
            try {
                messageJson = JSON.parse(message.utf8Data);
            }
            catch (ex) {
                connection.sendUTF('{ "msg":"error", "text":"Invalid JSON :(" }');
            }

            switch (messageJson.msg) {
                case "challenge_accepted":
                    if (!messageJson.team) {
                        connection.sendUTF('{ "msg":"error", "text":"Team name is empty :(" }');
                    } else {
                        var token = addTeam(messageJson.team, connection);
                        connection.sendUTF('{ "msg":"auth", "token":"'+token+'"}');
                    }
                    break;

                case "task1":
                    if (!messageJson.token) {
                        connection.sendUTF('{ "msg":"error", "text":"Token is empty :(" }');
                    } else {
                        if (!teams[messageJson.token]) {
                            connection.sendUTF('{ "msg":"error", "text":"Token is invalid :(" }');
                        } else {
                            var task = generateTask1();
                            teams[messageJson.token].task1 = task;
                            connection.sendUTF(JSON.stringify(task));
                        }
                    }
                    break;

                case "compute_result":
                    if (!messageJson.token) {
                        connection.sendUTF('{ "msg":"error", "text":"Token is empty :(" }');
                    } else {
                        if (!teams[messageJson.token]) {
                            connection.sendUTF('{ "msg":"error", "text":"Token is invalid :(" }');
                        } else {
                            if (teams[messageJson.token].task1) {
                                var result = computeTask1(teams[messageJson.token].task1);
                                teams[messageJson.token].task1 = null;
                                if (result == messageJson.result) {
                                    connection.sendUTF('{ "msg":"win", "text":"Awesome! now send `next` for task #2!" }');
                                } else {
                                    connection.sendUTF('{ "msg":"error", "text":"A miscalculation: '+result+' expected but received '+messageJson.result+'" }');
                                }
                            }
                        }
                    }
                    break;

                case "next":
                    if (!messageJson.token) {
                        connection.sendUTF('{ "msg":"error", "text":"Token is empty :(" }');
                    } else {
                        if (!teams[messageJson.token]) {
                            connection.sendUTF('{ "msg":"error", "text":"Token is invalid :(" }');
                        } else {
                            var task = generateTask2();
                            teams[messageJson.token].task2 = task;
                            connection.sendUTF(JSON.stringify(task[0]));
                            connection.sendBytes(toBuffer(task[1]));
                        }
                    }
                    break;

                case "binary_sum":
                    if (!messageJson.token) {
                        connection.sendUTF('{ "msg":"error", "text":"Token is empty :(" }');
                    } else {
                        if (!teams[messageJson.token]) {
                            connection.sendUTF('{ "msg":"error", "text":"Token is invalid :(" }');
                        } else {
                            if (teams[messageJson.token].task2) {
                                var result = computeTask2(teams[messageJson.token].task2);
                                teams[messageJson.token].task2 = null;
                                if (result == messageJson.result) {
                                    connection.sendUTF('{ "msg":"win", "text":"EPIC WIN", "code":"6455" }');
                                    if (!winner) { winner = teams[messageJson.token];
                                        console.log(teams[messageJson.token].name+" were the first to get through!"+(new Date()));
                                    }
                                } else {
                                    connection.sendUTF('{ "msg":"error", "text":"A miscalculation: '+result+' expected but received '+messageJson.result+'" }');
                                }
                            }
                        }
                    }
                    break;

                default:
                    connection.sendUTF('{ "msg":"error", "text":"Unknown message" }');
                    break;
            }

        }
    });
    connection.on('close', function(reasonCode, description) {
        console.log((new Date()) + ' Peer ' + connection.remoteAddress + ' disconnected.');
    });
});