import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/wishlist_item.dart';
import 'models/input_create.dart';
import 'models/input_update.dart';

class WishlistCreateFailure implements Exception {}

class WishlistUpdateFailure implements Exception {}

class WishlistDeleteFailure implements Exception {}

class WishlistFetchFailure implements Exception {}

class WishlistApiClient {
  WishlistApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://localhost:8080/api';
  final http.Client _httpClient;

  /// Method to create a wishlist item
  Future<String> createWishlistItem(
    WishlistCreateInput input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/wishlist');
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
      throw WishlistCreateFailure();
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as String;
  }

  /// Method to update a wishlist item
  Future<void> updateWishlistItem(
    String id,
    WishlistUpdateInput input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id');
    final jsonBody = jsonEncode(input.toJson());

    print('Sending PUT request to: $uri');
    print('Request body: $jsonBody');
    print('Authorization token: $token');

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to update wishlist item. Throwing WishlistUpdateFailure.');
      throw WishlistUpdateFailure();
    }

    print('Wishlist item updated successfully.');
  }

  /// Method to delete a wishlist item
  Future<void> deleteWishlistItem(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id');

    print('Sending DELETE request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to delete wishlist item. Throwing WishlistDeleteFailure.');
      throw WishlistDeleteFailure();
    }

    print('Wishlist item deleted successfully.');
  }

  Future<List<WishlistItem>> getWishlistItemsByUserID(String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/');

    print('Sending GET request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to fetch wishlist items. Throwing WishlistFetchFailure.');
      throw WishlistFetchFailure();
    }

    // Проверяем, если тело ответа пустое, возвращаем пустой список
    if (response.body.isEmpty) {
      print('Response body is empty. Returning an empty list.');
      return [];
    }

    try {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody is! List) {
        print('Response body is not a list. Returning an empty list.');
        return [];
      }

      final wishlistItems =
          responseBody.map((json) => WishlistItem.fromJson(json)).toList();
      print('Parsed wishlist items: $wishlistItems');

      return wishlistItems;
    } catch (e) {
      print('Error decoding response body: $e. Returning an empty list.');
      return [];
    }
  }

  /// Method to fetch wishlist items by user ID
  Future<List<WishlistItem>> getWishlistItemsByFamilyUserID(
    String token,
    String id,
  ) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id');

    print('Sending GET request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to fetch wishlist items. Throwing WishlistFetchFailure.');
      throw WishlistFetchFailure();
    }

    if (response.body.isEmpty || response.body == []) {
      print('Response body is empty. Returning an empty list.');
      return [];
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    print('Decoded response body: $responseBody');

    if (responseBody.isEmpty) {
      print('Response body is an empty list. Returning an empty list.');
      return [];
    }

    final wishlistItems =
        responseBody.map((json) => WishlistItem.fromJson(json)).toList();
    print('Parsed wishlist items: $wishlistItems');

    return wishlistItems;
  }

  /// Method to update the reserved by field of a wishlist item
  Future<void> updateReservedBy(
    String id,
    String reservedBy,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id/reserved_by');
    final jsonBody = jsonEncode({'reserved_by': reservedBy});

    print('Sending PUT request to: $uri');
    print('Request body: $jsonBody');
    print('Authorization token: $token');

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to update reserved by. Throwing WishlistUpdateFailure.');
      throw WishlistUpdateFailure();
    }

    print('Reserved by updated successfully.');
  }

  /// Method to fetch archived wishlist items by user ID
  Future<List<WishlistItem>> getArchivedByUserID(String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/archived');

    print('Sending GET request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print(
        'Failed to fetch archived wishlist items. Throwing WishlistFetchFailure.',
      );
      throw WishlistFetchFailure();
    }

    if (response.body.isEmpty || response.body == []) {
      print('Response body is empty. Returning an empty list.');
      return [];
    }

    final responseBody = jsonDecode(utf8.decode(response.bodyBytes)) as List;
    print('Decoded response body: $responseBody');

    if (responseBody.isEmpty) {
      print('Response body is an empty list. Returning an empty list.');
      return [];
    }

    final archivedItems =
        responseBody.map((json) => WishlistItem.fromJson(json)).toList();
    print('Parsed archived wishlist items: $archivedItems');

    return archivedItems;
  }

  /// Method to cancel update of the reserved by field of a wishlist item
  Future<void> cancelUpdateReservedBy(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id/cancel_reserved_by');

    print('Sending PUT request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.put(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print(
        'Failed to cancel update reserved by. Throwing WishlistUpdateFailure.',
      );
      throw WishlistUpdateFailure();
    }

    print('Cancelled update of reserved by successfully.');
  }

  void dispose() {
    _httpClient.close();
  }
}
