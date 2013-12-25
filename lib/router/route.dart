part of dhilla;

class Route {
  final String config,
               method;
  RegExp _parser = new RegExp(r'\(\?P<(\w+)>(.+?)\)'),
         regExp;
  Set<String> _keys;
  StreamController _controller = new StreamController();

  static const String GET    = 'GET',
                      POST   = 'POST',
                      PUT    = 'PUT',
                      DELETE = 'DELETE',
                      ANY    = 'ANY',
                      WS     = 'WS';

  factory Route.matchAllHttp() {
    var config = r'^(.+)$',
        method = Route.ANY,
        route = new Route(config, method);

    return route;
  }

  factory Route.MatchAllWS() {
    var config = r'^(.+)$',
        method = Route.WS,
        route = new Route(config, method);

    return route;
  }

  Route(this.config, this.method) {
    regExp = _getRegExp(config);
    _keys = _getKeys(config);
  }

  bool _checker(Transferables transferables) {
    var inputPath = transferables.path,
        inputMethod = transferables.method,
        isPathMatch = regExp.hasMatch(inputPath),
        isMethodMatch = method == Route.ANY
                        ? inputMethod == Route.GET  ||
                          inputMethod == Route.POST ||
                          inputMethod == Route.PUT  ||
                          inputMethod == Route.DELETE
                        : inputMethod == method;

    return isPathMatch && isMethodMatch;
  }

  RegExp _getRegExp(String input) {
    var parsed = input.replaceAllMapped(_parser, (match) => '(${match[2]})'),
        newRegExp = new RegExp(parsed);

    return newRegExp;
  }

  Set<String> _getKeys(String input) {
    var matches = _parser.allMatches(input);

    if (matches == null) return new Set();

    var newKeys = matches.map((match) => match[1]).toSet();

    return newKeys;
  }

  Set<String> _getValues(String input) {

    valueParser(value) {
      try {
        return int.parse(value);
      } catch (error) {
        try {
          return double.parse(value);
        } catch (e) {
          return value;
        }
      }
    }

    var match = regExp.firstMatch(input),
        index = new List.generate(match.groupCount,
                                  (i) => i + 1,
                                  growable: false),
        values = match.groups(index).map(valueParser).toSet();
    return values;
  }

  Stream get stream => _controller.stream.transform(new _ParamsFiller(this));
}

