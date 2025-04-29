import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishlist_api/wishlist_api.dart';

class WishlistRepository {
  WishlistRepository({WishlistApiClient? wishlistApiClient})
    : _wishlistApiClient = wishlistApiClient ?? WishlistApiClient();

  final WishlistApiClient _wishlistApiClient;
  final _wishlistController = StreamController<List<WishlistItem>>();
  String? _familyId;

  /// Поток для элементов списка желаний
  Stream<List<WishlistItem>> get wishlistItems async* {
    try {
      final items = await fetchWishlistItems();
      yield items;
      yield* _wishlistController.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Метод для обновления familyId
  void updateFamilyId(String? familyId) {
    _familyId = familyId;
    print('Family ID updated: $_familyId');
  }

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Получение элементов списка желаний
  Future<List<WishlistItem>> fetchWishlistItems() async {
    try {
      print('Fetching wishlist items...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }
      print('JWT token retrieved: $token');

      final items = await _wishlistApiClient.getWishlistItemsByUserID(token);
      print('Wishlist items fetched successfully: $items');
      return items;
    } catch (e) {
      print(
        'WishlistRepository - fetchWishlistItems - Failed to fetch wishlist items: $e',
      );
      throw Exception('Failed to fetch wishlist items');
    }
  }

  /// Создание элемента списка желаний
  Future<String> createWishlistItem({
    required String name,
    required String description,
    required String link,
  }) async {
    try {
      print('Starting to create a new wishlist item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      final wishlistCreateInput = WishlistCreateInput(
        name: name,
        description: description,
        link: link,
      );
      print('WishlistCreateInput prepared: $wishlistCreateInput');

      final wishlistItemId = await _wishlistApiClient.createWishlistItem(
        wishlistCreateInput,
        token,
      );
      print('Wishlist item created successfully with ID: $wishlistItemId');

      final updatedWishlistItems = await fetchWishlistItems();
      print('Updated wishlist items fetched: $updatedWishlistItems');
      _wishlistController.add(updatedWishlistItems);

      return wishlistItemId;
    } catch (e) {
      print('Failed to create wishlist item: $e');
      throw WishlistCreateFailure();
    }
  }

  /// Обновление элемента списка желаний
  Future<void> updateWishlistItem({
    required String id,
    required String name,
    required String description,
    required String link,
    required String status,
    required bool isArchived,
  }) async {
    try {
      print('Starting to update a wishlist item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      final wishlistUpdateInput = WishlistUpdateInput(
        name: name,
        description: description,
        link: link,
        status: status,
        isArchived: isArchived,
      );
      print('WishlistUpdateInput prepared: $wishlistUpdateInput');

      await _wishlistApiClient.updateWishlistItem(
        id,
        wishlistUpdateInput,
        token,
      );
      print('Wishlist item updated successfully');

      final updatedWishlistItems = await fetchWishlistItems();
      print('Updated wishlist items fetched: $updatedWishlistItems');
      _wishlistController.add(updatedWishlistItems);
    } catch (e) {
      print('Failed to update wishlist item: $e');
      throw WishlistUpdateFailure();
    }
  }

  /// Удаление элемента списка желаний
  Future<void> deleteWishlistItem(String id) async {
    try {
      print('Starting to delete a wishlist item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _wishlistApiClient.deleteWishlistItem(id, token);
      print('Wishlist item deleted successfully');

      final updatedWishlistItems = await fetchWishlistItems();
      print('Updated wishlist items fetched: $updatedWishlistItems');
      _wishlistController.add(updatedWishlistItems);
    } catch (e) {
      print('Failed to delete wishlist item: $e');
      throw WishlistDeleteFailure();
    }
  }

  /// Получение архивированных элементов списка желаний
  Future<List<WishlistItem>> fetchArchivedWishlistItems() async {
    try {
      print('Fetching archived wishlist items...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }
      print('JWT token retrieved: $token');

      final archivedItems = await _wishlistApiClient.getArchivedByUserID(token);
      print('Archived wishlist items fetched successfully: $archivedItems');
      return archivedItems;
    } catch (e) {
      print(
        'WishlistRepository - fetchArchivedWishlistItems - Failed to fetch archived wishlist items: $e',
      );
      throw Exception('Failed to fetch archived wishlist items');
    }
  }

  /// Обновление поля reservedBy элемента списка желаний
  Future<void> updateReservedBy({
    required String id,
    required String reservedBy,
  }) async {
    try {
      print('Starting to update reservedBy field of a wishlist item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _wishlistApiClient.updateReservedBy(id, reservedBy, token);
      print('ReservedBy field updated successfully');

      final updatedWishlistItems = await fetchWishlistItems();
      print('Updated wishlist items fetched: $updatedWishlistItems');
      _wishlistController.add(updatedWishlistItems);
    } catch (e) {
      print('Failed to update reservedBy field: $e');
      throw WishlistUpdateFailure();
    }
  }

  /// Получение элементов списка желаний по ID пользователя семьи
  Future<List<WishlistItem>> fetchWishlistItemsByFamilyUserID(
    String userId,
  ) async {
    try {
      print('Fetching wishlist items by family user ID...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }
      print('JWT token retrieved: $token');

      final items = await _wishlistApiClient.getWishlistItemsByFamilyUserID(
        token,
        userId,
      );
      print('Wishlist items by family user ID fetched successfully: $items');
      return items;
    } catch (e) {
      print(
        'WishlistRepository - fetchWishlistItemsByFamilyUserID - Failed to fetch wishlist items by family user ID: $e',
      );
      throw Exception('Failed to fetch wishlist items by family user ID');
    }
  }

  /// Отмена обновления поля reservedBy элемента списка желаний
  Future<void> cancelUpdateReservedBy(String id) async {
    try {
      print('Starting to cancel update of reservedBy field...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _wishlistApiClient.cancelUpdateReservedBy(id, token);
      print('Cancelled update of reservedBy field successfully');

      final updatedWishlistItems = await fetchWishlistItems();
      print('Updated wishlist items fetched: $updatedWishlistItems');
      _wishlistController.add(updatedWishlistItems);
    } catch (e) {
      print('Failed to cancel update of reservedBy field: $e');
      throw WishlistUpdateFailure();
    }
  }

  void dispose() {
    _wishlistController.close();
  }
}
