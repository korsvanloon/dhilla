
# Dhilla

A simple wrapper around Dart's vanilla HttpServer

```dart
import 'package:dhilla/dhilla.dart';

void main() {
  var server = new Server('127.0.0.1', 8080);

//  intercept request object, to do some processing if you want.
//  must return request object or future of request object
//  request object can be a Request or a WSRequest, also known as Transferables
  server
    ..use((request) {
      request['name'] = 'my name is John Doe';
      return request;
    })
    ..use((request) {
      request['age'] = 'and my age is 50';
      return request;
    });

  var router = new Router(server);

  router
    ..get(r'^/$').listen((Request request) {
      var response = request.response;

      response.send('Hello world!');
    })
    ..get(r'^/(?P<first>\w+)/(?P<last>\w+)/$').listen((Request request) {
      var response = request.response,
          params = request.params;
//      params is a Map containing first and last as key
      response.sendJSON(params);
    })
    ..post(r'^/post/$').listen((Request request) {
      var form = request.body,
          response = request.response;
//      any post data is available through body
//      do some form processing
      response.sendJSON(form);
    })
    ..defaultHttpHandler.listen((Request request) {
      var response = request.response;

//      render index.html
      response.sendFile('index.html');
    });
}
```

## API

### Server
extends Stream.
Start Server by listening to it.
```dart
get address;
int get port;
int get backlog;
HttpServer get httpServer;
bool get isUp;
bool get isDown;
```

#### Routes
Route Transferables based on config and its method.

Transferables has params, it's a map containing a kwargs based on config.
For example: 
```dart
r'^/(?P<name>\w+)/(?P<age>\d+)/$'
```
if we have a request path like
this: /johndoe/9123/

params will be 
```dart
{'name' : johndoe, 'age': 9123}
```
To catch value, define your config with the following
```dart
(?P<thisIsYourKey>thisIsYourRegex)
 ```
 
```dart
get(String config); // handle GET request
post(String config); // handle POST request
put(String config); // handle PUT request
delete(String config); // handle DELETE request
ws(String config); // handle websocket request
any(String config); // handle any verb request except websocket
get defaultHttpHandler; // handle any request with any verb except websocket
                        // that didn't match any
get defaultWSHandler; // same with above except this one handle websocket
```

### Request
implements HttpRequest

```dart
final String type; // contain values like 'json', 'text', 'form'
                   // based on what you submit
final body; // the actual data
final Map params; // see above                   
String get(name); // get header
bool get isAjax; // is request an ajax request?
bool get isWS; // is request a websocket request?
String get path; // request path
String get method; // request method
```

### Response
extends HttpResponse
```dart
String get(String name); // get header
void set(String name, Object value) // set header
Future send(val); // same as write() 
sendAll(iterable, separator); // same as writeAll()
sendCharCode(charCode); // same as writeCharCode()
sendln(); // same as writeln()
sendJSON(obj); // send json, works only with List or Map
sendFile(path, {override: true}); // send file, if override is true 
                                  // it will try to determine the file
                                  // mime-type and override mime-type
                                  // you already specify. 
```

any method with 'send' prefix is write() followed by close() on response. 

### WSRequest
extends Stream implements WebSocket
```dart
String get path;
String get method;
final Map params;
final Request request;
```

## License
(The MIT License)

Copyright (c) 2013 Faris Nasution <nasution.faris@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.