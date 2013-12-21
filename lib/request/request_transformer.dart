part of dhilla;

class RequestTransformer extends Transformer {

  void handleData(HttpRequest httpRequest, EventSink sink) {
    HttpBodyHandler
      .processRequest(httpRequest)
      .then((requestBody) => new Request(requestBody.request,
                                         requestBody.type,
                                         requestBody.body))
      .then((request) => sink.add(request));
  }
}

