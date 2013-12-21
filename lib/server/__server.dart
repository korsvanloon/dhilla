part of dhilla;

class _Server extends Stream implements Server {
  final address;
  final int port, backlog;
  HttpServer _httpServer;
  StreamController _controller;

  _Server(this.address, this.port, this.backlog) {
    _controller = new StreamController(onListen: _onListen, onCancel: close);
  }

  @override
  StreamSubscription listen(void onData(event),
                            {Function onError,
                             void onDone(),
                             bool cancelOnError}) {
    _controller.stream.listen(onData,
                              onError: onError,
                              onDone: onDone,
                              cancelOnError: cancelOnError);
  }

  void _onListen() {
    if (isDown) {
      HttpServer
        .bind(address, port, backlog: backlog)
        .then((server) {
          _httpServer = server;

          _httpServer
            .transform(new RequestTransformer())
            .transform(new WSRequestTransformer())
            .listen((request) => _controller.add(request));
        });
    }
  }

  Future close() =>
      _httpServer.close()
        .then((_) => _httpServer = null)
        .then((_) => _controller.close());

  bool get isUp => _httpServer != null;

  bool get isDown => _httpServer == null;

  HttpServer get httpServer => _httpServer;
}