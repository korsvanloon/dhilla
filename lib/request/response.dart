part of dhilla;

const MIME = const {
  'txt': 'text/plain; charset=utf-8',
  'json': 'application/json',
  'mp4': 'video/mp4',
  'css': 'text/css',
  'html': 'text/html; charset=utf-8',
  'png': 'image/png',
  'jpg': 'image/jpeg',
  'js': 'text/javascript',
  'gif' : 'image/gif',
  'webm': 'video/webm',
  'mp3' : 'audio/mpeg'
};

class Response extends HttpResponse {
  HttpResponse _response;

  Response(this._response);

  void add(List<int> data) => _response.add(data);

  void addError(error, [StackTrace stackTrace]) =>
      _response.addError(error, stackTrace);

  Future addStream(Stream<List<int>> stream) => _response.addStream(stream);

  Future close() => _response.close();

  HttpConnectionInfo get connectionInfo => _response.connectionInfo;

  List<Cookie> get cookies => _response.cookies;

  Future<Socket> detachSocket() => _response.detachSocket();

  Future get done => _response.done;

  Encoding get encoding => _response.encoding;

  void set encoding(Encoding _encoding) {
    _response.encoding = _encoding;
  }

  Future flush() => _response.flush();

  HttpHeaders get headers => _response.headers;

  Future redirect(Uri location, {int status: HttpStatus.MOVED_TEMPORARILY}) {
    return _response.redirect(location, status: status);
  }

  void write(Object obj) => _response.write(obj);

  void writeAll(Iterable objects, [String separator = ''])
      => _response.writeAll(objects, separator);

  void writeCharCode(int charCode) => _response.writeCharCode(charCode);

  void writeln([Object obj = '']) => _response.writeln(obj);

  String get(String name) => _response.headers.value(name);

  void set(String name, Object value) => _response.headers.set(name, value);

  Future send(Object obj) {
    _response.write(obj);
    return _response.close();
  }

  Future sendAll(Iterable objects, [String separator = '']) {
    _response.writeAll(objects, separator);
    return _response.close();
  }

  Future sendCharCode(int charCode) {
    _response.writeCharCode(charCode);
    return _response.close();
  }

  Future sendln([Object obj = '']) {
    _response.writeln(obj);
    return _response.close();
  }

  Future sendJSON(Object obj) {
    var c = new Completer();

    new Future(() => obj is Map || obj is List)
      .then((result) => result ? result : throw '<$obj> is not a List or a Map')
      .then((_) => JSON.encode(obj))
      .then((json) {
        _response.headers
            ..set(HttpHeaders.CONTENT_TYPE, 'application/json')
            ..set(HttpHeaders.CONTENT_LENGTH, json.length);
        return json;
      })
      .then((json) => _response.write(json))
      .then(c.complete)
      .catchError((error, stackTrace) => c.completeError(error, stackTrace));

    return c.future;
  }

  Future sendFile(String path, {override: true}) {
    var c = new Completer(),
        file = new File(path);

    file
      .exists()
      .then((result) => result ? result : throw HttpStatus.NOT_FOUND)
      .then((_) => file.length())
      .then((length) =>
          _response.headers.set(HttpHeaders.CONTENT_LENGTH, length))
      .then((_) {
        var ext = file.path.split('.').last;

        if (override)
          _response.headers.set(HttpHeaders.CONTENT_TYPE, MIME[ext]);
        return ;
      })
      .then((_) => file.openRead().pipe(_response))
      .then(c.complete)
//      .catchError((error, stackTrace) {
//
//      }, test: (error) => error == 404)
      .catchError((error, stackTrace) => c.completeError(error, stackTrace));

    return c.future;
  }

}