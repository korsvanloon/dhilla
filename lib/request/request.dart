part of dhilla;

abstract class Transferables {
  String get method;
  String get path;
  Map get params;
}

class Request extends Stream implements HttpRequest, Transferables {
  HttpRequest _request;
  Response _response;
  final String type;
  final body;
  final Map params = {};
  Map _map = {};

  Request(this._request, this.type, this.body) {
    _response = new Response(_request.response);
  }

  @override
  StreamSubscription<List<int>> listen(void onData(List<int> event),
                                       {Function onError,
                                        void onDone(),
                                        bool cancelOnError}) {
    return _request.listen(onData,
                           onError: onError,
                           onDone: onDone,
                           cancelOnError: cancelOnError);
  }

  operator [](String key) => _map[key];

  operator []=(String key, Object value) => _map[key] = value;

  X509Certificate get certificate => _request.certificate;

  HttpConnectionInfo get connectionInfo => _request.connectionInfo;

  int get contentLength => _request.contentLength;

  List<Cookie> get cookies => _request.cookies;

  HttpHeaders get headers => _request.headers;

  String get method => _request.method;

  bool get persistentConnection => _request.persistentConnection;

  String get protocolVersion => _request.protocolVersion;

  Response get response => _response;

  HttpSession get session => _request.session;

  Uri get uri => _request.uri;

  String get path => _request.uri.path;

  String get(String name) => _request.headers.value(name);

  bool get isAjax {
    var ajax = _request.headers.value('x-requested-with');

    return ajax != null && ajax == 'XmlHttpRequest';
  }

  bool get isWS {
    var ws = _request.headers.value('upgrade');

    return ws != null && ws == 'websocket';
  }
}
