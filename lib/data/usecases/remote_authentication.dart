import 'package:meta/meta.dart';

import '/domain/usecases/usecases.dart';
import '/domain/entities/entities.dart';
import '/domain/helpers/helpers.dart';

import '../http/http.dart';
import '../models/models.dart';

class RemoteAuthentication {
  final HttpClient? httpClient;
  final String? url;

  RemoteAuthentication({required this.httpClient, required this.url});

  Future<RemoteAccountModel> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJason();
    try {
      final Map? httpResponse = await httpClient?.request(
        url: url,
        method: 'post',
        body: body,
      );
      return RemoteAccountModel.fromJson(httpResponse!);
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredencials
          : DomainError.unexpected;
    }
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
