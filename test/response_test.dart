part of dhilla.test;

void responseTest() {
  group('Response test', () {
    var mockHttpResponse,
        mockHttpHeaders;

    setUp(() {
      mockHttpResponse = new MockHttpResponse();
      mockHttpHeaders = new MockHttpHeaders();

      mockHttpResponse
        .when(callsTo('get headers')).alwaysReturn(mockHttpHeaders);
    });

    test('get()', () {
      var response = new Response(mockHttpResponse);

      mockHttpHeaders
        .when(callsTo('value'))
        .thenReturn('faris')
        .thenReturn('ok');

      expect(response.get('test'), equals('faris'));
      expect(response.get('test lagi'), equals('ok'));
    });

    test('set()', () {
      var response = new Response(mockHttpResponse),
          map = {};

      mockHttpHeaders
        ..when(callsTo('set'))
          .alwaysCall((name, value) {
            map[name] = value;
          });

      response
        ..set('name', 'faris')
        ..set('status', 'ok');

      mockHttpHeaders
        ..when(callsTo('value', 'name')).alwaysReturn(map['name'])
        ..when(callsTo('value', 'status')).alwaysReturn(map['status']);

      print(map);
      expect(response.get('name'), equals('faris'));
      expect(response.get('status'), equals('ok'));
    });
  });
}