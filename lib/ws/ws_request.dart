part of dhilla;

class WSRequest extends Stream implements WebSocket {
  final WebSocket _ws;
  final Request request;
  Map _map = {};

  WSRequest(this._ws, this.request);

  operator [](String name) => _map[name];

  void operator []=(String name, Object value) {
    _map[name] = value;
  }

  void add(data) => _ws.add(data);

  void addError(errorEvent, [StackTrace stackTrace]) =>
      _ws.addError(errorEvent, stackTrace);

  Future addStream(Stream stream) => _ws.addStream(stream);

  Future close([int code, String reason]) => _ws.close(code, reason);

  int get closeCode => _ws.closeCode;

  String get closeReason => _ws.closeReason;

  Future get done => _ws.done;

  String get extensions => _ws.extensions;

  @override
  StreamSubscription listen(void onData(event),
                            {Function onError,
                             void onDone(),
                             bool cancelOnError}) {
    return _ws.listen(onData,
                      onError: onError,
                      onDone: onDone,
                      cancelOnError: cancelOnError);
  }

  Duration get pingInterval => _ws.pingInterval;

  void set pingInterval(Duration _pingInterval) {
    _ws.pingInterval = _pingInterval;
  }

  String get protocol => _ws.protocol;

  int get readyState => _ws.readyState;
}