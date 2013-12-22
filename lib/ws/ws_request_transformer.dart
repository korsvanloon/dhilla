part of dhilla;

class WSRequestTransformer extends Transformer {

  void handleData(Request request, EventSink sink) {
    if (request.isWS) {
      WebSocketTransformer
      .upgrade(request)
      .then((ws) {
        var wsRequest = new WSRequest(ws, request);

        sink.add(wsRequest);
      });
    }
    sink.add(request);
  }

}
