part of dhilla.test;

void requestTest() {
  group('Request test', () {
    var mockHttpRequest,
        mockHttpHeaders;

    setUp(() {
      mockHttpRequest = new MockHttpRequest();
      mockHttpHeaders = new MockHttpHeaders();

      mockHttpRequest
        .when(callsTo('get headers'))
        .alwaysReturn(mockHttpHeaders);
    });

    test('ajax getter', () {
      var request = new Request(mockHttpRequest, 'text', 'fwefewf');

      mockHttpHeaders
        .when(callsTo('value', 'x-requested-with'))
        .thenReturn(null)
        .thenReturn('XmlHttpRequest');

      expect(request.type, equals('text'));
      expect(request.body, equals('fwefewf'));
      expect(request.isAjax, isFalse);
      expect(request.isAjax, isTrue);
    });

    test('websocket getter', () {
      var request = new Request(mockHttpRequest, 'text', 'fwefewf');

      mockHttpHeaders
        .when(callsTo('value', 'upgrade'))
        .thenReturn(null)
        .thenReturn('websocket');

      expect(request.type, equals('text'));
      expect(request.body, equals('fwefewf'));
      expect(request.isWS, isFalse);
      expect(request.isWS, isTrue);
    });

    test('get()', () {
      var request = new Request(mockHttpRequest, 'text', 'fwefewf');

      mockHttpHeaders
        .when(callsTo('value'))
        .thenReturn('ok')
        .thenReturn('not ok');

      expect(request.get('not ok'), equals('ok'));
      expect(request.get('ok'), equals('not ok'));
    });

    test('path getter', () {
      var request = new Request(mockHttpRequest, 'text', 'fwefewf'),
          uri = Uri.parse('/faris/1/?age=22');

      mockHttpRequest.when(callsTo('get uri')).alwaysReturn(uri);

      expect(request.path, equals('/faris/1/'));
      expect(request.uri.queryParameters, equals(uri.queryParameters));
    });

  });
}