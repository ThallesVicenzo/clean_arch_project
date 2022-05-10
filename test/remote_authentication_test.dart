import 'package:flutter_test/flutter_test.dart';
import '';

class RemoteAuthentication {
  Future<void> auth() async {}
}

void main() {
  test('Shold call HttpClient with correct URL', () async {
    final HttpClient = HttpClient();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(HttpClient: HttpClient, url: url);

    await sut.auth();

    verify(httpClient.request(url: url));
  });
}