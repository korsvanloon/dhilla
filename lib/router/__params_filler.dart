part of dhilla;

class _ParamsFiller extends Transformer {
  final Route _route;

  _ParamsFiller(this._route);

  @override
  void handleData(Transferables transferables, EventSink sink) {
    var values = _route._getValues(transferables.path),
        params = new Map.fromIterables(_route._keys, values);

    transferables.params.addAll(params);
    sink.add(transferables);
  }
}