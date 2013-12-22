part of dhilla;

typedef Middleware(request);

class _Server extends Stream implements Server {
  final address;
  final int port, backlog;
  HttpServer _httpServer;
  StreamController _controller;
  Set<Middleware> _middlewares = new Set<Middleware>();

  _Server(this.address, this.port, this.backlog) {
    _controller = new StreamController(onListen: _onListen, onCancel: close);
  }

  void use(Middleware callback) {
    _middlewares.add(callback);
  }

  @override
  StreamSubscription listen(void onData(event),
                            {Function onError,
                             void onDone(),
                             bool cancelOnError}) {
    return _controller
           .stream
           .map((request) {
             if (_middlewares.isNotEmpty)
               _middlewares.forEach((middleware) =>
                   request = middleware(request));
             return request;
           })
           .listen(onData,
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