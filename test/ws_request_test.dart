part of dhilla.test;

void wsRequestTest() {
  group('WSRequest test', () {

    var mockWS,
        mockRequest;

    setUp(() {
      mockWS = new MockWebSocket();
      mockRequest = new MockRequest();
    });

    test('request getter', () {
      var wsRequest = new WSRequest(mockWS, mockRequest);

      expect(wsRequest.request, isHttpRequest);
      expect(wsRequest.request, isRequest);
    });

    test('method getter', () {
      var wsRequest = new WSRequest(mockWS, mockRequest);

      expect(wsRequest.method, equals('WS'));
    });

    test('path getter', () {
      var wsRequest = new WSRequest(mockWS, mockRequest);

      mockRequest.when(callsTo('get path')).alwaysReturn('/faris/1/');

      expect(wsRequest.path, equals('/faris/1/'));
    });

  });
}