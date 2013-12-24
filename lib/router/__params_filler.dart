part of dhilla;

class _ParamsFiller extends Transformer {
  final Route _route;

  _ParamsFiller(this._route);

  @override
  void handleData(Transferables transferables, EventSink sink) {
    var keys = _route._keys;

    if (keys.isNotEmpty) {
      var values = _route._getValues(transferables.path),
          params = new Map.fromIterables(keys, values);

      transferables.params.addAll(params);
    }

    sink.add(transferables);
  }
}