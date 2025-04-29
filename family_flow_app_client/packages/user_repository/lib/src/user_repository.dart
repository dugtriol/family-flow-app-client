import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_api/user_api.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  UserRepository({UserApiClient? userApiClient})
    : _userApiClient = userApiClient ?? UserApiClient();

  final UserApiClient _userApiClient;
  User? _user;

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Получение данных пользователя
  Future<User?> getUser() async {
    print("getUser");
    if (_user != null) return _user;

    final token = await _getJwtToken();
    print("getUser - token: $token");
    if (token == null) {
      print("getUser - token is null");
      return Future.delayed(
        const Duration(milliseconds: 300),
        () => _user = User.empty,
      );
    }

    try {
      final userGet = await _userApiClient.getUser(token);
      print("getUser - userGet: $userGet");

      // Преобразуем UserGet в User
      _user = User(
        id: userGet.id,
        name: userGet.name,
        email: userGet.email,
        role: userGet.role,
        familyId: userGet.familyId,
      );
      print("getUser - user: $_user");
      return _user;
    } catch (e) {
      print("getUser - error: $e");
      return Future.delayed(
        const Duration(milliseconds: 300),
        () => _user = User.empty,
      );
    }
  }

  /// Update user information
  Future<void> updateUser(UserUpdateInput input) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      await _userApiClient.updateUser(token, input);
    } catch (e) {
      print("updateUser - error: $e");
      rethrow;
    }
  }
}
