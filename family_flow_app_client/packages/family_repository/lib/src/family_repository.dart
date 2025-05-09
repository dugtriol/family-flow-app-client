import 'dart:async';
import 'dart:io' show File;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:family_api/family_api.dart';
import 'package:user_api/user_api.dart' show User;
import 'package:user_repository/user_repository.dart' show UserRepository;

class FamilyRepository {
  FamilyRepository({
    FamilyApiClient? familyApiClient,
    required UserRepository userRepository,
  }) : _familyApiClient = familyApiClient ?? FamilyApiClient(),
       _userRepository = userRepository;

  final FamilyApiClient _familyApiClient;
  final UserRepository _userRepository;
  final _controller = StreamController<List<User>>();

  Stream<List<User>> get familyMembers async* {
    try {
      final user = await getCurrentUser();
      if (user.familyId!.isEmpty) {
        yield [];
        return;
      }
      final members = await fetchFamilyMembers(user.familyId!);
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
      _controller.add(await fetchFamilyMembers(user.familyId!));
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
      _controller.add(await fetchFamilyMembers(user.familyId!));
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

      print('FamilyRepository - Fetched family members: ${output.users}');

      return output.users;
    } catch (e) {
      print('Failed to fetch family members: $e');
      throw Exception('Failed to fetch family members');
    }
  }

  /// Удаление участника из семьи
  Future<void> removeMemberFromFamily(String memberId, String familyId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      await _familyApiClient.resetFamilyId(
        ResetFamilyIdInput(id: memberId, familyId: familyId),
        token,
      );
      // final user = await getCurrentUser();
      _controller.add(await fetchFamilyMembers(familyId));
    } catch (e) {
      print('Failed to remove member from family: $e');
      throw Exception('Failed to remove member from family');
    }
  }

  /// Добавление участника в семью
  Future<void> inviteMemberToFamily(InputAddMemberToFamily input) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      await _familyApiClient.inviteMemberToFamily(input, token);
      final user = await getCurrentUser();
      _controller.add(await fetchFamilyMembers(user.familyId!));
    } catch (_) {
      throw Exception('Failed to add member to family');
    }
  }

  // --REWARDS--

  Future<String> createReward(RewardCreateInput input) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }
      final output = await _familyApiClient.createReward(input, token);
      print('FamilyRepository - Created reward: $output');
      return output;
    } catch (e) {
      print('Family Repository - Failed to create reward: $e');
      throw Exception('Failed to create reward');
    }
  }

  /// Получение списка вознаграждений семьи
  Future<List<Reward>> getRewardsByFamilyID(String familyId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _familyApiClient.getRewardsByFamilyID(familyId, token);
    } catch (e) {
      print('Failed to get rewards: $e');
      throw Exception('Failed to get rewards');
    }
  }

  /// Получение очков пользователя
  Future<int> getPoints(String userId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _familyApiClient.getPoints(userId, token);
    } catch (e) {
      print('Failed to get points: $e');
      throw Exception('Failed to get points');
    }
  }

  /// Обменять очки на вознаграждение
  Future<void> redeemReward(String rewardId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      await _familyApiClient.redeemReward(rewardId, token);
    } catch (e) {
      print('Failed to redeem reward: $e');
      throw Exception('Failed to redeem reward');
    }
  }

  /// Получение списка обменов пользователя
  Future<List<RewardRedemption>> getRedemptionsByUserID(String userId) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _familyApiClient.getRedemptionsByUserID(userId, token);
    } catch (e) {
      print('Failed to get redemptions: $e');
      throw Exception('Failed to get redemptions');
    }
  }

  Future<void> updateFamilyPhoto(String familyId, File photo) async {
    final token = await _getJwtToken();
    if (token == null) {
      throw Exception('JWT token is missing');
    }

    final input = InputUpdatePhoto(familyId: familyId, photo: photo);

    await _familyApiClient.updateFamilyPhoto(input, token);
  }

  void dispose() => _controller.close();
}
