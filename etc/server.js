var redis = require("redis");
var client = redis.createClient();

var server = http.createServer();
server.listen(parseInt(process.env.PORT), "66.228.56.230");

var io = require("socket.io").listen(server);

client.on("message", function (channel, message) {
    io.sockets.emit(channel, message);
});

client.subscribe("printatcu:print");