part of dhilla;

abstract class Server {
  get address;
  int get port;
  int get backlog;
  HttpServer get httpServer;
  StreamController _controller;
  Set _middlewares;

  factory Server(address, int port, {int backlog: 0}) =>
      new _Server(address, port, backlog);

  void use(Middleware callback);
  Future close();
  void _onListen();

  bool get isUp;
  bool get isDown;
}
