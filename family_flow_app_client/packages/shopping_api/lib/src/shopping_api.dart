// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/shopping_api/lib/src/shopping_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/shopping_item.dart';
import 'models/input_create.dart';
import 'models/input_update.dart';

class ShoppingCreateFailure implements Exception {}

class ShoppingUpdateFailure implements Exception {}

class ShoppingDeleteFailure implements Exception {}

class ShoppingFetchFailure implements Exception {}

class ShoppingApiClient {
  ShoppingApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  // static const _baseUrl = 'http://10.0.2.2:8080/api';
  // static const _baseUrl = 'http://family-flow-app-aigul.amvera.io/api';
  static const _baseUrl = 'http://family-flow-app-1-aigul.amvera.io/api';
  final http.Client _httpClient;

  /// Method to create a shopping item
  Future<String> createShoppingItem(
    ShoppingCreateInput input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/shopping');
    final jsonBody = jsonEncode(input.toJson());

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 201) {
      throw ShoppingCreateFailure();
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as String;
  }

  /// Method to update a shopping item
  Future<void> updateShoppingItem(
    String id,
    ShoppingUpdateInput input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/shopping/$id');
    final jsonBody = jsonEncode(input.toJson());

    print('isArchived: ${input.isArchived}');
    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw ShoppingUpdateFailure();
    }
  }

  /// Method to delete a shopping item
  Future<void> deleteShoppingItem(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/$id');

    final response = await _httpClient.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw ShoppingDeleteFailure();
    }
  }

  /// Method to fetch public shopping items by family ID
  // Future<List<ShoppingItem>> getPublicShoppingItems(
  //   String familyId,
  //   String token,
  // ) async {
  //   final uri = Uri.parse('$_baseUrl/shopping/public?family_id=$familyId');
  //   print('Fetching public shopping items for family ID: $familyId');

  //   final response = await _httpClient.get(
  //     uri,
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   print('Response status code: ${response.statusCode}');
  //   if (response.statusCode != 200) {
  //     print('Failed to fetch public shopping items. Throwing exception.');
  //     throw ShoppingFetchFailure();
  //   }

  //   final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
  //   print('Successfully fetched public shopping items: $responseBody');
  //   return responseBody.map((json) => ShoppingItem.fromJson(json)).toList();
  // }
  Future<List<ShoppingItem>> getPublicShoppingItems(
    String familyId,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/shopping/public?family_id=$familyId');
    print('Fetching public shopping items for family ID: $familyId');

    try {
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode != 200) {
        print(
          'Failed to fetch public shopping items. Returning an empty list.',
        );
        return [];
      }

      if (response.body.isEmpty || response.body == 'null') {
        print('Response body is empty or null. Returning an empty list.');
        return [];
      }

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      print('Successfully fetched public shopping items: $responseBody');
      return responseBody.map((json) => ShoppingItem.fromJson(json)).toList();
    } catch (e) {
      print(
        'Error fetching public shopping items: $e. Returning an empty list.',
      );
      return [];
    }
  }

  /// Method to fetch private shopping items by created by
  // Future<List<ShoppingItem>> getPrivateShoppingItems(String token) async {
  //   final uri = Uri.parse('$_baseUrl/shopping/private');

  //   final response = await _httpClient.get(
  //     uri,
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode != 200) {
  //     throw ShoppingFetchFailure();
  //   }

  //   final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
  //   return responseBody.map((json) => ShoppingItem.fromJson(json)).toList();
  // }
  Future<List<ShoppingItem>> getPrivateShoppingItems(String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/private');
    print('Fetching private shopping items...');

    try {
      final response = await _httpClient.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Response status code: ${response.statusCode}');
      if (response.statusCode != 200) {
        print(
          'Failed to fetch private shopping items. Returning an empty list.',
        );
        return [];
      }

      if (response.body.isEmpty || response.body == 'null') {
        print('Response body is empty or null. Returning an empty list.');
        return [];
      }

      final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
      print('Successfully fetched private shopping items: $responseBody');
      return responseBody.map((json) => ShoppingItem.fromJson(json)).toList();
    } catch (e) {
      print(
        'Error fetching private shopping items: $e. Returning an empty list.',
      );
      return [];
    }
  }

  /// Method to delete a shopping item by ID
  Future<String> deleteShoppingItemById(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/$id');
    print('Deleting shopping item with ID: $id');

    final response = await _httpClient.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('Failed to delete shopping item. Throwing exception.');
      throw ShoppingDeleteFailure();
    }

    final responseBody = utf8.decode(response.bodyBytes);
    print('Successfully deleted shopping item: $responseBody');
    return responseBody;
  }

  /// Method to update the reserved by field of a shopping item
  Future<void> updateReservedBy(
    String id,
    String reservedBy,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/shopping/reserved/$id');
    final jsonBody = jsonEncode({'reserved_by': reservedBy});

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw ShoppingUpdateFailure();
    }
  }

  /// Method to update the buyer ID of a shopping item
  Future<void> updateBuyerId(String id, String buyerId, String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/buyer/$id');
    final jsonBody = jsonEncode({'buyer_id': buyerId});

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode != 200) {
      throw ShoppingUpdateFailure();
    }
  }

  /// Method to fetch archived shopping items by user ID
  Future<List<ShoppingItem>> getArchivedShoppingItems(String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/archived');

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw ShoppingFetchFailure();
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    return responseBody.map((json) => ShoppingItem.fromJson(json)).toList();
  }

  /// Method to cancel the reserved by field of a shopping item
  Future<void> cancelReservedBy(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/shopping/cancel_reserved/$id');
    print('Canceling reserved by for shopping item with ID: $id');

    final response = await _httpClient.put(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('Failed to cancel reserved by. Throwing exception.');
      throw ShoppingUpdateFailure();
    }

    print('Successfully canceled reserved by for shopping item.');
  }

  void close() {
    _httpClient.close();
  }
}
