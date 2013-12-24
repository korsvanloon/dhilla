part of dhilla;

typedef Transferables Middleware(Transferables transferables);

class _Middleware extends Transformer {
  Middleware _middleware;

  _Middleware(this._middleware);

  @override
  void handleData(transferables, EventSink sink) {
    new Future(() => _middleware(transferables))
      .then((result) => sink.add(result))
      .catchError((error, stackTrace) => sink.addError(error, stackTrace));
  }
}
