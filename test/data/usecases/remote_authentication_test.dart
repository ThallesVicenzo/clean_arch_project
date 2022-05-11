
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_arch_project/domain/usecases/usecases.dart';
import 'package:clean_arch_project/domain/helpers/helpers.dart';

import 'package:clean_arch_project/data/usecases/usecases.dart';
import 'package:clean_arch_project/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  RemoteAuthentication? sut;
  HttpClientSpy? httpClient;
  String? url;
  AuthenticationParams? params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(
      httpClient: httpClient,
      url: url,
    );
    params = AuthenticationParams(
        email: faker.internet.email(), secret: faker.internet.password());
  });

  test('Should call HttpClient with correct URL', () async {
    await sut?.auth(params!);

    verify(
      httpClient?.request(
        url: url,
        method: 'post',
        body: {
          'email': params?.email,
          'password': params?.secret,
        },
      ),
    );
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(
      httpClient?.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.badRequest);

    final future = sut?.auth(params!);

    expect(future, throwsA(DomainError.unexpected));
  });
}
