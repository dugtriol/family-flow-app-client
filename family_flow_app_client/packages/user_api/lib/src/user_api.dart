import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

class UserFetchFailure implements Exception {}

class UserApiClient {
  UserApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  // static const _baseUrl = 'http://10.0.2.2:8080/api';
  // static const _baseUrl = 'http://family-flow-app-aigul.amvera.io/api';
  static const _baseUrl = 'http://family-flow-app-1-aigul.amvera.io/api';
  final http.Client _httpClient;

  Future<User> getUser(String token) async {
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
    final user = User.fromJson(responseBody);
    print('UserGet object created: $user');
    return user;
  }

  Future<void> updateUser(String token, UserUpdateInput input) async {
    print(
      'user-api-updateUser: updateUser called with token: $token and input: ${input.toJson()}',
    );
    final uri = Uri.parse('$_baseUrl/user');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['name'] = input.name;
    request.fields['email'] = input.email;
    request.fields['role'] = input.role;
    request.fields['gender'] = input.gender;
    if (input.birthDate != null) {
      request.fields['birth_date'] =
          input.birthDate!.toIso8601String().split('T').first;
    }
    request.fields['avatar_url'] = input.avatarURL;

    // Добавляем файл аватара, если он есть
    if (input.avatar != null) {
      request.files.add(
        await http.MultipartFile.fromPath('avatar', input.avatar!.path),
      );
    }

    // Добавляем заголовок авторизации
    request.headers['Authorization'] = 'Bearer $token';

    // Отправляем запрос
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.reasonPhrase}');
    }
  }

  /// Метод для обновления геолокации пользователя
  Future<void> updateUserLocation({
    required double latitude,
    required double longitude,
    required String token,
  }) async {
    print(
      'user-api-updateUserLocation: Called with latitude: $latitude, longitude: $longitude, token: $token',
    );
    final uri = Uri.parse('$_baseUrl/user/location');
    print('user-api-updateUserLocation: Constructed URI: $uri');

    final jsonBody = jsonEncode({'latitude': latitude, 'longitude': longitude});
    print('user-api-updateUserLocation: JSON body: $jsonBody');

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    print(
      'user-api-updateUserLocation: Response received with status code: ${response.statusCode}',
    );

    if (response.statusCode != 200) {
      print(
        'user-api-updateUserLocation: Failed to update user location. Response body: ${response.body}',
      );
      throw Exception('Failed to update user location: ${response.body}');
    }

    print('user-api-updateUserLocation: Location updated successfully.');
  }

  void close() {
    _httpClient.close();
  }
}
