import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_repository/user_repository.dart';

import 'models/models.dart';

class FamilyCreateFailure implements Exception {}

class FamilyApiClient {
  FamilyApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://localhost:8080/api';
  final http.Client _httpClient;

  /// Метод для создания семьи
  Future<void> createFamily(FamilyCreateInput family, String token) async {
    print('createFamily called with family: ${family.toJson()}');
    final uri = Uri.parse('$_baseUrl/family');
    print('Constructed URI: $uri');

    final jsonBody = jsonEncode(family.toJson());
    print('JSON body: $jsonBody');
    print('Token: $token');

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 201) {
      print('Response status code is not 201. Throwing FamilyCreateFailure.');
      print('Response body: ${response.body}');
      throw FamilyCreateFailure();
    }

    print('Family created successfully.');
  }

  /// Method to add a member to a family
  Future<void> addMemberToFamily(
      InputAddMemberToFamily input, String token) async {
    final uri = Uri.parse('$_baseUrl/family/add');
    final jsonBody = jsonEncode(input.toJson());

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add member to family: ${response.body}');
    }
  }

  /// Method to get members of a family
  Future<OutputGetMembers> getFamilyMembers(
      InputGetMembers input, String token) async {
    final uri = Uri.parse('$_baseUrl/family/members');
    final jsonBody = jsonEncode(input.toJson());

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get family members: ${response.body}');
    }

    // print('Response body: ${response.body}');
    if (response.body.isEmpty || response.body == 'null') {
      // print('Response body is empty or null');
      return OutputGetMembers(users: []);
    }

    try {
      // Парсим массив JSON
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final users = responseData
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>))
          .toList();
      return OutputGetMembers(users: users);
    } catch (e) {
      print('Failed to parse response body: $e');
      return OutputGetMembers(users: []);
    }
  }

  void close() {
    _httpClient.close();
  }
}
