import 'package:clean_arch_project/domain/entities/account_entity.dart';
import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';

import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient? httpClient;
  final String? url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<void>? auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJason();
    await httpClient?.request(
      url: url,
      method: 'post',
      body: body,
    );
  }
}

class RemoteAuthenticationParams {
  final String? email;
  final String? password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.secret,
      );

  Map toJason() => {'email': email, 'password': password};
}
