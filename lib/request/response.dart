part of dhilla;

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

  void writeAll(Iterable objects, [String separator = ""])
  => _response.writeAll(objects, separator);

  void writeCharCode(int charCode) => _response.writeCharCode(charCode);

  void writeln([Object obj = ""]) => _response.writeln(obj);

  String get(String name) => _response.headers.value(name);

  void set(String name, Object value) => _response.headers.set(name, value);
}