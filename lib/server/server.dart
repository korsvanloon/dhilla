part of dhilla;

abstract class Server {
  get address;
  int get port;
  int get backlog;
  HttpServer get httpServer;
  StreamController _controller;
  Set _middlewares;

  void use(Middleware callback);
  Future close();
  void _onListen();

  bool get isUp;
  bool get isDown;
}
