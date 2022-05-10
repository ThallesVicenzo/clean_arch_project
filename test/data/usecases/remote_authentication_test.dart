import 'package:test/test.dart';
import 'package:faker/faker.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mockito/mockito.dart';
import 'package:meta/meta.dart';


class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient{
  Future<void> request({
    @required String url
  });
}

class HttpClientSpy extends Mock implements HttpClient{}

void main() {
  test('Should call HttpClient with correct URL', () async {
    final HttpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: HttpClient, url: url);

    await sut.auth();

    verify(HttpClient.request(url: url));
  });
}