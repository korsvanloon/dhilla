part of dhilla.test;

const isHttpRequest = const _IsHttpRequest();
const isRequest = const _IsRequest();

class _IsHttpRequest extends TypeMatcher {
  const _IsHttpRequest() : super('HttpRequest');
  bool matches(item, Map matchState) => item is HttpRequest;
}

class _IsRequest extends TypeMatcher {
  const _IsRequest() : super('Request');
  bool matches(item, Map matchState) => item is Request;
}