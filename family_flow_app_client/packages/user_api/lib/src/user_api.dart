import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

class UserFetchFailure implements Exception {}

class UserApiClient {
  UserApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://localhost:8080/api';
  final http.Client _httpClient;

  Future<UserGet> getUser(String token) async {
    print('getUser called with token: $token');
    final uri = Uri.parse('$_baseUrl/user');
    print('Constructed URI: $uri');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing UserFetchFailure.');
      throw UserFetchFailure();
    }

    final responseBody =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    print('Response body decoded: $responseBody');
    final user = UserGet.fromJson(responseBody);
    print('UserGet object created: $user');
    return user;
  }

  Future<void> updateUser(String token, UserUpdateInput input) async {
    print(
      'user-api-updateUser: updateUser called with token: $token and input: ${input.toJson()}',
    );
    final uri = Uri.parse('$_baseUrl/user');
    print('user-api-updateUser: Constructed URI: $uri');

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );
    print(
      'user-api-updateUser: Response received with status code: ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      print(
        'user-api-updateUser: Response status code is not 200. Throwing UserFetchFailure.',
      );
      throw UserFetchFailure();
    }

    print('user-api-updateUser: updateUser completed successfully.');
  }

  void close() {
    _httpClient.close();
  }
}
