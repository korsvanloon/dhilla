part of dhilla.test;

void serverTest() {

  group('Server test', () {
    var server,
        address,
        port;

    setUp(() {
      address = '127.0.0.1';
      port = 8080;
      server = new Server(address, port);
    });

    tearDown(() => server.close());

    test('isDown getter', () {
      expect(server.isDown, isTrue);
    });

    test('isUp getter', () {
      server.listen(((request) {
        expect(server.isUp, isTrue);
        request.response.close();
      }));

      var client = new HttpClient();

      client
        .get(address, port, '/')
        .then(expectAsync1((request) => request.close()))
        .then(expectAsync1((response) => response.statusCode))
        .whenComplete(expectAsync0(() {
          client.close();
        }));
    });

    test('use middleware to populate map inside of Request', () {
      var firstMiddleware = (request) {
        request['name'] = 'faris';
        request['age'] = 22;
        return request;
      },
          secondMiddleware = (request) {
        request['hobby'] = ['ngoding', 'dota'];
        return request;
      };

      server
        ..use(firstMiddleware)
        ..use(secondMiddleware)
        ..listen((request) {
          expect(request['name'], equals('faris'));
          expect(request['age'], equals(22));
          expect(request['hobby'], equals(['ngoding', 'dota']));
          request.response.close();
      });

      var client = new HttpClient();

      client
        .get(address, port, '/')
        .then(expectAsync1((request) => request.close()))
        .then(expectAsync1((response) => response.statusCode))
        .whenComplete(expectAsync0(() {
          client.close();
        }));
    });

  });

}
