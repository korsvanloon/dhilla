part of dhilla.test;

void routerTest() {
  group('Router test', () {
    var controller,
        transferables;

    setUp(() {
      controller = new StreamController();
      transferables = new MockTransferables();

      transferables.when(callsTo('get params')).alwaysReturn({});
    });

    tearDown(() => transferables.reset());

    test('handle http get request', () {
      var router = new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.GET);

      router
        .get(r'^/faris/1/$').listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isEmpty);
        }));

      controller.add(transferables);
    });

    test('handle any request except ws', () {
      var router = new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.PUT);

      router
        .any(r'^/faris/1/$').listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isEmpty);
        }));

      controller.add(transferables);
    });

    test('handle ws request', () {
      var router = new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.WS);

      router
        .ws(r'^/faris/1/$').listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isEmpty);
        }));

      controller.add(transferables);
    });

    test('handle request with params', () {
      var router = new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.DELETE);

      router
        .delete(r'^/(?P<name>\w+)/(?P<id>\w+)/$').listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isNot(isEmpty));
          expect(data.params['name'], equals('faris'));
          expect(data.params['id'], equals(1));
        }));

      controller.add(transferables);
    });

    test('using default http handler', () {
      var router =  new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.POST);

      router
        ..get(r'^/faris/1/$').listen(print)
        ..delete(r'^/faris/1/$').listen(print)
        ..put(r'^/faris/1/$').listen(print)
        ..ws(r'^/faris/1/$').listen(print)
        ..defaultHttpHandler.listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isEmpty);
        }));

      controller.add(transferables);
    });

    test('using default ws handler', () {
      var router =  new Router(controller.stream);

      transferables
        ..when(callsTo('get path')).alwaysReturn('/faris/1/')
        ..when(callsTo('get method')).alwaysReturn(Route.WS);

      router
        ..ws(r'^/$').listen(print)
        ..ws(r'^/faris$').listen(print)
        ..defaultWSHandler.listen(expectAsync1((data) {
          expect(data, isTransferables);
          expect(data.params, isEmpty);
        }));

      controller.add(transferables);
    });

  });
}