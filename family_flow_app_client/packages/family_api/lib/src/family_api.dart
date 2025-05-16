import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:user_api/user_api.dart' show User;

import 'models/models.dart';

class FamilyCreateFailure implements Exception {}

class FamilyApiClient {
  FamilyApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  // static const _baseUrl = 'http://10.0.2.2:8080/api';
  // static const _baseUrl = 'http://family-flow-app-aigul.amvera.io/api';
  static const _baseUrl = 'http://family-flow-app-1-aigul.amvera.io/api';
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

  // --- REWARDS ---

  Future<String> createReward(RewardCreateInput input, String token) async {
    final uri = Uri.parse('$_baseUrl/rewards');
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
      throw Exception('Failed to create reward: ${response.body}');
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final output = responseData['reward_id'] as String;
    print('createReward - output: $output');
    return output;
  }

  /// Получить список вознаграждений семьи
  Future<List<Reward>> getRewardsByFamilyID(
    String familyId,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/rewards?family_id=$familyId');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get rewards: ${response.body}');
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
    print('getRewardsByFamilyID - Response body: ${response.body}');
    print('responseBody == null: ${responseBody == null}');
    print('responseBody is List: ${responseBody is! List}');
    print('response.body.isEmpty: ${response.body.isEmpty}');
    print('response.body is List: ${response.body is! List}');
    if (responseBody == null ||
        responseBody is! List ||
        response.body.isEmpty) {
      print(
        'API вернул null или некорректный формат. Возвращаем пустой список.',
      );
      return [];
    }

    final responseData =
        jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return responseData
        .map(
          (rewardJson) => Reward.fromJson(rewardJson as Map<String, dynamic>),
        )
        .toList();
  }

  /// Получить очки пользователя
  Future<int> getPoints(String userId, String token) async {
    final uri = Uri.parse('$_baseUrl/rewards/points?user_id=$userId');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get points: ${response.body}');
    }

    final responseData =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return responseData['points'] as int;
  }

  /// Обменять очки на вознаграждение
  Future<void> redeemReward(String rewardId, String token) async {
    final uri = Uri.parse('$_baseUrl/rewards/$rewardId/redeem');

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to redeem reward: ${response.body}');
    }
  }

  /// Получить список обменов пользователя
  Future<List<RewardRedemption>> getRedemptionsByUserID(
    String userId,
    String token,
  ) async {
    // final uri = Uri.parse('$_baseUrl/rewards/redemptions?user_id=$userId');
    final uri = Uri.parse('$_baseUrl/rewards/redemptions');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('getRedemptionsByUserID - Response body: ${response.body}');
    if (response.statusCode != 200) {
      print('getRedemptionsByUserID - Response body: ${response.body}');
      print(
        'getRedemptionsByUserID - Response status code: ${response.statusCode}',
      );
      throw Exception('Failed to get redemptions: ${response.body}');
    }

    print(
      'getRedemptionsByUserID - response.body.isEmpty: ${response.body.isEmpty}',
    );
    print(
      'getRedemptionsByUserID - response.body == null: ${response.body == 'null'}',
    );
    print(
      'getRedemptionsByUserID - response.body is List: ${response.body is! List}',
    );

    // || response.body is! List
    if (response.body.isEmpty || response.body == 'null') {
      print(
        'getRedemptionsByUserID - API вернул null или некорректный формат. Возвращаем пустой список.',
      );
      return []; // Возвращаем пустой список, если данных нет
    }

    // final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    // final responseData = jsonDecode(responseBody) as List<dynamic>;
    // final wishlistItems =
    //     responseBody.map((json) => WishlistItem.fromJson(json)).toList();
    try {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return responseBody
          .map((redemptionJson) => RewardRedemption.fromJson(redemptionJson))
          .toList();
    } catch (e) {
      print('Failed to parse redemptions: $e');
      return []; // Возвращаем пустой список в случае ошибки парсинга
    }
  }

  Future<void> updateFamilyPhoto(InputUpdatePhoto input, String token) async {
    final uri = Uri.parse('$_baseUrl/family/photo');

    final request =
        http.MultipartRequest('PUT', uri)
          ..fields['familyId'] = input.familyId
          ..headers['Authorization'] = 'Bearer $token';

    // Добавляем файл фото
    if (input.photo != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo', // Ключ должен совпадать с серверным
          input.photo!.path,
        ),
      );
    } else {
      throw Exception('Photo file is missing');
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update family photo: ${response.reasonPhrase}',
      );
    }
  }

  Future<void> updateReward(
    RewardUpdateInput input,
    String rewardId,
    String token,
  ) async {
    print('updateReward called with input: ${input.toJson()}');
    final uri = Uri.parse('$_baseUrl/rewards/$rewardId');
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
      throw Exception('Failed to update reward: ${response.body}');
    }
  }

  Future<List<RewardRedemption>> getRedemptionsByUserIDParam(
    String userId,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/rewards/redemptions/$userId');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('getRedemptionsByUserIDParam - Response body: ${response.body}');
    if (response.statusCode != 200) {
      print('getRedemptionsByUserIDParam - Response body: ${response.body}');
      print(
        'getRedemptionsByUserIDParam - Response status code: ${response.statusCode}',
      );
      throw Exception('Failed to get redemptions: ${response.body}');
    }

    print(
      'getRedemptionsByUserIDParam - response.body.isEmpty: ${response.body.isEmpty}',
    );
    print(
      'getRedemptionsByUserIDParam - response.body == null: ${response.body == 'null'}',
    );
    print(
      'getRedemptionsByUserIDParam - response.body is List: ${response.body is! List}',
    );

    if (response.body.isEmpty || response.body == 'null') {
      print(
        'getRedemptionsByUserIDParam - API returned null or invalid format. Returning an empty list.',
      );
      return [];
    }

    try {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      return responseBody
          .map((redemptionJson) => RewardRedemption.fromJson(redemptionJson))
          .toList();
    } catch (e) {
      print('Failed to parse redemptions: $e');
      return [];
    }
  }

  /// Удаление награды
  Future<void> deleteReward(String rewardId, String token) async {
    final uri = Uri.parse('$_baseUrl/rewards/$rewardId');

    final response = await _httpClient.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete reward: ${response.body}');
    }

    print('Reward deleted successfully: $rewardId');
  }

  void close() {
    _httpClient.close();
  }
}
