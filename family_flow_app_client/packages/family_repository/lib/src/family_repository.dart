import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:family_api/family_api.dart';
import 'package:user_repository/user_repository.dart' show User, UserRepository;

class FamilyRepository {
  FamilyRepository({
    FamilyApiClient? familyApiClient,
    required UserRepository userRepository,
  })  : _familyApiClient = familyApiClient ?? FamilyApiClient(),
        _userRepository = userRepository;

  final FamilyApiClient _familyApiClient;
  final UserRepository _userRepository;
  final _controller = StreamController<List<User>>();

  Stream<List<User>> get familyMembers async* {
    try {
      final user = await getCurrentUser();
      if (user.familyId.isEmpty) {
        yield [];
        return;
      }
      final members = await fetchFamilyMembers(user.familyId);
      yield members;
      yield* _controller.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Получение текущего пользователя из UserRepository
  Future<User> getCurrentUser() async {
    final user = await _userRepository.getUser();
    if (user == User.empty) {
      throw Exception('No current user found');
    }
    return user!;
  }

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Family> getFamilyById(String familyId) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('JWT token is missing');
    }
    return await _familyApiClient.getFamilyById(familyId, token);
  }

  /// Создание семьи
  Future<void> createFamily(FamilyCreateInput family) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      await _familyApiClient.createFamily(family, token);
      final user = await getCurrentUser();
      _controller.add(await fetchFamilyMembers(user.familyId));
    } catch (_) {
      throw FamilyCreateFailure();
    }
  }

  /// Добавление участника в семью
  Future<void> addMemberToFamily(InputAddMemberToFamily input) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      await _familyApiClient.addMemberToFamily(input, token);
      final user = await getCurrentUser();
      _controller.add(await fetchFamilyMembers(user.familyId));
    } catch (_) {
      throw Exception('Failed to add member to family');
    }
  }

  /// Получение участников семьи
  Future<List<User>> fetchFamilyMembers(String familyId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      final output = await _familyApiClient.getFamilyMembers(
        InputGetMembers(familyId: familyId),
        token,
      );

      return output.users;
    } catch (e) {
      print('Failed to fetch family members: $e');
      throw Exception('Failed to fetch family members');
    }
  }

  void dispose() => _controller.close();
}
