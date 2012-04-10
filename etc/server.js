var redis = require("redis");
var client = redis.createClient();

var io = require("socket.io").listen(parseInt(process.env.PORT));

io.configure(function () {
  io.set("transports", ["xhr-polling"]);
  io.set("polling duration", 10);
});

client.on("message", function (channel, message) {
    io.sockets.emit(channel, message);
});

client.subscribe("printatcu:print");