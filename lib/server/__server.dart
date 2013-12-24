part of dhilla;

class _Server extends Stream implements Server {
  final address;
  final int port, backlog;
  HttpServer _httpServer;
  StreamController _controller;
  Set<StreamTransformer> _middlewares = new Set<StreamTransformer>();

  _Server(this.address, this.port, this.backlog) {
    _controller = new StreamController(onListen: _onListen, onCancel: close);
  }

  void use(Middleware callback) {
    var middleware = new _Middleware(callback);

    _middlewares.add(middleware);
  }

  @override
  StreamSubscription listen(void onData(event),
                            {Function onError,
                             void onDone(),
                             bool cancelOnError}) {
    var stream = _controller.stream;

    if (_middlewares.isNotEmpty)
      _middlewares.forEach((middleware) {
        stream = stream.transform(middleware);
      });

    return stream.listen(onData,
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

  Future close() {
    if (isUp)
      return _httpServer.close()
              .then((_) => _httpServer = null)
              .then((_) => _controller.close());
  }

  bool get isUp => _httpServer != null;

  bool get isDown => _httpServer == null;

  HttpServer get httpServer => _httpServer;
}