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

  });
}