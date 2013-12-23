part of dhilla;

class Router {
  Stream _source;
  StreamSubscription _subscription;
  Set<Route> _routes = new Set<Route>();
  StreamController _controller = new StreamController();

  Router(this._source) {
    _subscription = _source.listen(_onData);
  }

  void _onData(Transferables transferables) {
    var controller = _selectMatch(transferables);

    controller.add(transferables);
  }

  StreamController _selectMatch(Transferables transferables) {
    var firstMatch = _routes
          .firstWhere((route) => route._checker(transferables), orElse: null),
        controller = firstMatch == null ? _controller : firstMatch._controller;

    return controller;
  }

  Stream handler(String config, String method) {
    var route = new Route(config, method);

    _routes.add(route);
    return route.stream;
  }

  Stream get defaultHandler => _controller.stream;
}
