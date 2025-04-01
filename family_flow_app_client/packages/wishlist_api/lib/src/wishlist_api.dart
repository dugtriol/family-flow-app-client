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
      WishlistCreateInput input, String token) async {
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

    return jsonDecode(response.body) as String;
  }

  /// Method to update a wishlist item
  Future<void> updateWishlistItem(
      String id, WishlistUpdateInput input, String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id');
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
      throw WishlistUpdateFailure();
    }
  }

  /// Method to delete a wishlist item
  Future<void> deleteWishlistItem(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist/$id');

    final response = await _httpClient.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw WishlistDeleteFailure();
    }
  }

  /// Method to fetch wishlist items by user ID
  Future<List<WishlistItem>> getWishlistItemsByUserID(String token) async {
    final uri = Uri.parse('$_baseUrl/wishlist');

    print('Sending GET request to: $uri');
    print('Authorization token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to fetch wishlist items. Throwing WishlistFetchFailure.');
      throw WishlistFetchFailure();
    }

    final responseBody = jsonDecode(response.body) as List;
    print('Decoded response body: $responseBody');

    final wishlistItems =
        responseBody.map((json) => WishlistItem.fromJson(json)).toList();
    print('Parsed wishlist items: $wishlistItems');

    return wishlistItems;
  }

  void close() {
    _httpClient.close();
  }
}
