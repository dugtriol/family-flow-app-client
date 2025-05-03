import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_api/shopping_api.dart';

class ShoppingRepository {
  ShoppingRepository({ShoppingApiClient? shoppingApiClient})
    : _shoppingApiClient = shoppingApiClient ?? ShoppingApiClient();

  final ShoppingApiClient _shoppingApiClient;
  final _publicController = StreamController<List<ShoppingItem>>();
  final _privateController = StreamController<List<ShoppingItem>>();
  String? _familyId; // Поле для хранения familyId

  /// Поток для публичных элементов
  Stream<List<ShoppingItem>> get publicShoppingItems async* {
    try {
      final items = await fetchPublicShoppingItems();
      yield items;
      yield* _publicController.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Поток для приватных элементов
  Stream<List<ShoppingItem>> get privateShoppingItems async* {
    try {
      final items = await fetchPrivateShoppingItems();
      yield items;
      yield* _privateController.stream;
    } catch (_) {
      yield [];
    }
  }

  String get familyId {
    return _familyId ?? '';
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

  /// Получение публичных элементов
  Future<List<ShoppingItem>> fetchPublicShoppingItems() async {
    try {
      print('Fetching public shopping items...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      if (_familyId == null) {
        print('Family ID is missing');
        throw Exception('Family ID is missing');
      }

      print('Fetching public shopping items with Family ID: $_familyId');
      final items = await _shoppingApiClient.getPublicShoppingItems(
        _familyId!,
        token,
      );
      print('Public shopping items fetched successfully: $items');
      return items;
    } catch (e) {
      print('Failed to fetch public shopping items: $e');
      throw Exception('Failed to fetch public shopping items');
    }
  }

  /// Получение приватных элементов
  Future<List<ShoppingItem>> fetchPrivateShoppingItems() async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _shoppingApiClient.getPrivateShoppingItems(token);
    } catch (e) {
      print('Failed to fetch private shopping items: $e');
      throw Exception('Failed to fetch private shopping items');
    }
  }

  /// Получение User ID из SharedPreferences
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Создание элемента списка покупок
  Future<String> createShoppingItem({
    required String title,
    required String description,
    required String visibility,
  }) async {
    try {
      print('Starting to create a new shopping item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      if (_familyId == null) {
        print('Family ID is missing');
        throw Exception('Family ID is missing');
      }

      print('Preparing ShoppingCreateInput with:');
      print('Title: $title');
      print('Description: $description');
      print('Visibility: $visibility');
      print('Family ID: $_familyId');
      final shoppingCreateInput = ShoppingCreateInput(
        familyId: _familyId!,
        title: title,
        description: description,
        visibility: visibility,
      );
      print('ShoppingCreateInput prepared: $shoppingCreateInput');

      final shoppingItemId = await _shoppingApiClient.createShoppingItem(
        shoppingCreateInput,
        token,
      );
      print('Shopping item created successfully with ID: $shoppingItemId');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);

      return shoppingItemId;
    } catch (e) {
      print('Failed to create shopping item: $e');
      throw ShoppingCreateFailure();
    }
  }

  /// Обновление элемента списка покупок
  Future<void> updateShoppingItem({
    required String id,
    required String title,
    required String description,
    required String status,
    required String visibility,
    required bool isArchived,
  }) async {
    try {
      print('Starting to update a shopping item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      if (_familyId == null) {
        print('Family ID is missing');
        throw Exception('Family ID is missing');
      }

      final shoppingUpdateInput = ShoppingUpdateInput(
        // id: id,
        title: title,
        description: description,
        status: status,
        visibility: visibility,
        isArchived: isArchived,
      );
      print('ShoppingUpdateInput prepared: $shoppingUpdateInput');

      print('Title: ${shoppingUpdateInput.title}');
      print('Description: ${shoppingUpdateInput.description}');
      print('Status: ${shoppingUpdateInput.status}');
      print('Visibility: ${shoppingUpdateInput.visibility}');
      print('Is Archived: ${shoppingUpdateInput.isArchived}');

      await _shoppingApiClient.updateShoppingItem(
        id,
        shoppingUpdateInput,
        token,
      );
      print('Shopping item updated successfully');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);
    } catch (e) {
      print('Failed to update shopping item: $e');
      throw ShoppingUpdateFailure();
    }
  }

  /// Удаление элемента списка покупок
  Future<void> deleteShoppingItem(String id) async {
    try {
      print('Starting to delete a shopping item...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _shoppingApiClient.deleteShoppingItem(id, token);
      print('Shopping item deleted successfully');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);
    } catch (e) {
      print('Failed to delete shopping item: $e');
      throw ShoppingDeleteFailure();
    }
  }

  /// Обновление поля reservedBy элемента списка покупок
  Future<void> updateReservedBy({
    required String id,
    required String reservedBy,
  }) async {
    try {
      print('Starting to update reservedBy field...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _shoppingApiClient.updateReservedBy(id, reservedBy, token);
      print('ReservedBy field updated successfully');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);
    } catch (e) {
      print('Failed to update reservedBy field: $e');
      throw ShoppingUpdateFailure();
    }
  }

  /// Обновление поля buyerId элемента списка покупок
  Future<void> updateBuyerId({
    required String id,
    required String buyerId,
  }) async {
    try {
      print('Starting to update buyerId field...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _shoppingApiClient.updateBuyerId(id, buyerId, token);
      print('BuyerId field updated successfully');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);
    } catch (e) {
      print('Failed to update buyerId field: $e');
      throw ShoppingUpdateFailure();
    }
  }

  /// Получение архивированных элементов списка покупок
  Future<List<ShoppingItem>> fetchArchivedShoppingItems() async {
    try {
      print('Fetching archived shopping items...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      final items = await _shoppingApiClient.getArchivedShoppingItems(token);
      print('Archived shopping items fetched successfully: $items');
      return items;
    } catch (e) {
      print('Failed to fetch archived shopping items: $e');
      throw Exception('Failed to fetch archived shopping items');
    }
  }

  /// Отмена поля reservedBy элемента списка покупок
  Future<void> cancelReservedBy(String id) async {
    try {
      print('Starting to cancel reservedBy field...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _shoppingApiClient.cancelReservedBy(id, token);
      print('ReservedBy field canceled successfully');

      final updatedShoppingItems = await fetchPublicShoppingItems();
      print('Updated shopping items fetched: $updatedShoppingItems');
      _publicController.add(updatedShoppingItems);
    } catch (e) {
      print('Failed to cancel reservedBy field: $e');
      throw ShoppingUpdateFailure();
    }
  }

  /// Закрытие потоков
  void dispose() {
    _publicController.close();
    _privateController.close();
  }
}
