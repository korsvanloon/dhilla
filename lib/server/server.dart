part of dhilla;

abstract class Server {
  get address;
  int get port;
  int get backlog;
  HttpServer get httpServer;
  StreamController _controller;

  Future close();
  void _onListen();

  bool get isUp;
  bool get isDown;
}
