import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_api/user_api.dart';

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
  // Future<User?> getUser() async {
  //   print("getUser");
  //   if (_user != null) return _user;

  //   final token = await _getJwtToken();
  //   print("getUser - token: $token");
  //   if (token == null) {
  //     print("getUser - token is null");
  //     return Future.delayed(
  //       const Duration(milliseconds: 300),
  //       () => _user = User.empty,
  //     );
  //   }

  //   try {
  //     final _user = await _userApiClient.getUser(token);
  //     print("getUser - userGet: $_user");

  //     // Преобразуем UserGet в User
  //     // _user = User(
  //     //   id: userGet.id,
  //     //   name: userGet.name,
  //     //   email: userGet.email,
  //     //   role: userGet.role,
  //     //   familyId: userGet.familyId,
  //     // );
  //     print("getUser - user: $_user");
  //     return _user;
  //   } catch (e) {
  //     print("getUser - error: $e");
  //     return Future.delayed(
  //       const Duration(milliseconds: 300),
  //       () => _user = User.empty,
  //     );
  //   }
  // }

  Future<User?> getUser() async {
    print("getUser");
    // if (_user != null) return _user;

    final token = await _getJwtToken();
    print("getUser - token: $token");
    if (token == null) {
      print("getUser - token is null");
      return null;
    }

    try {
      _user = await _userApiClient.getUser(token);
      print("getUser - userGet: $_user");
      return _user;
    } catch (e) {
      print("getUser - error: $e");
      return null;
    }
  }

  /// Update user information
  Future<void> updateUser(UserUpdateInput input) async {
    print("updateUser - start: $input");
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

  /// Метод для обновления геолокации пользователя
  Future<void> updateUserLocation({
    required double latitude,
    required double longitude,
  }) async {
    print(
      "updateUserLocation - start: latitude=$latitude, longitude=$longitude",
    );

    final token = await _getJwtToken();
    if (token == null) {
      print("updateUserLocation - error: JWT token is missing");
      throw Exception('JWT token is missing');
    }

    try {
      await _userApiClient.updateUserLocation(
        latitude: latitude,
        longitude: longitude,
        token: token,
      );
      print("updateUserLocation - success");
    } catch (e) {
      print("updateUserLocation - error: $e");
      rethrow;
    }
  }
}
