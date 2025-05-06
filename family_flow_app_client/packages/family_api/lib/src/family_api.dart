import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_repository/user_repository.dart';

import 'models/models.dart';

class FamilyCreateFailure implements Exception {}

class FamilyApiClient {
  FamilyApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://10.0.2.2:8080/api';
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
    InputAddMemberToFamily input,
    String token,
  ) async {
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
    InputGetMembers input,
    String token,
  ) async {
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

    print('getFamilyMembers - body: ${response.body}');

    // print('Response body: ${response.body}');
    if (response.body.isEmpty || response.body == 'null') {
      // print('Response body is empty or null');
      return OutputGetMembers(users: []);
    }

    try {
      // Парсим массив JSON
      // final responseData =
      //     jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

      // final users =
      //     responseData
      //         .map(
      //           (userJson) => User.fromJson(userJson as Map<String, dynamic>),
      //         )
      //         .toList();
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final users =
          (body['list'] as List)
              .map(
                (memberJson) =>
                    User.fromJson(memberJson as Map<String, dynamic>),
              )
              .toList();
      print('getFamilyMembers - Parsed users: $users');
      return OutputGetMembers(users: users);
    } catch (e) {
      print('Failed to parse response body: $e');
      return OutputGetMembers(users: []);
    }
  }

  /// Method to get family by ID
  Future<Family> getFamilyById(String familyId, String token) async {
    print('getFamilyById called with familyId: $familyId');
    final uri = Uri.parse('$_baseUrl/family/$familyId');
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
      print('Failed to get family by ID. Response body: ${response.body}');
      throw Exception('Failed to get family by ID: ${response.body}');
    }

    try {
      final responseData =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      print('Response data: $responseData');
      return Family.fromJson(responseData);
    } catch (e) {
      print('Failed to parse family data: $e');
      throw Exception('Failed to parse family data: $e');
    }
  }

  /// Method to reset user family IDvoid close() {
  Future<void> resetFamilyId(ResetFamilyIdInput input, String token) async {
    final uri = Uri.parse('$_baseUrl/user/family_id');
    final jsonBody = jsonEncode(input.toJson());

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset family ID: ${response.body}');
    }
  }

  /// Method to add a member to a family
  Future<void> inviteMemberToFamily(
    InputAddMemberToFamily input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/family/invite');
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
      throw Exception('Failed to invite member to family: ${response.body}');
    }
  }

  void close() {
    _httpClient.close();
  }
}
