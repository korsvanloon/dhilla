part of dhilla;

class Router {
  Stream _source;
  StreamSubscription _subscription;
  Set<Route> _routes = new Set<Route>();
  Route _defaultHttpRoute = new Route.matchAllHttp(),
        _defaultWSRoute = new Route.MatchAllWS();

  Router(this._source) {
    _subscription = _source.listen(_onData);
  }

  void _onData(Transferables transferables) {
    var controller = _selectMatch(transferables);

    controller.add(transferables);
  }

  StreamController _selectMatch(Transferables transferables) {
    var newRoute = transferables.method == Route.WS
                   ? _defaultWSRoute
                   : _defaultHttpRoute,
        firstMatch = _routes.firstWhere((route) =>
            route._checker(transferables), orElse: () => null),
        controller = firstMatch == null
                     ? newRoute._controller
                     : firstMatch._controller;

    return controller;
  }

  Stream handler(String config, String method) {
    var route = new Route(config, method);

    _routes.add(route);
    return route.stream;
  }

  Stream get defaultHttpHandler => _defaultHttpRoute.stream;

  Stream get defaultWSHandler => _defaultWSRoute.stream;
}
