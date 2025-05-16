import 'dart:async';
import 'dart:io' show File;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_api/family_api.dart';
import 'package:family_repository/family_repository.dart'; // Ensure this is the correct path
import 'package:user_api/user_api.dart' show User;
import 'package:user_repository/user_repository.dart';

import '../../authentication/authentication.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc({
    required FamilyRepository familyRepository,
    required AuthenticationBloc authenticationBloc,
  }) : _familyRepository = familyRepository,
       _authenticationBloc = authenticationBloc,
       super(FamilyInitial()) {
    on<FamilyRequested>(_onFamilyRequested);
    on<FamilyCreateRequested>(_onFamilyCreateRequested);
    on<FamilyJoinRequested>(_onFamilyJoinRequested);
    on<FamilyAddMemberRequested>(_onFamilyAddMemberRequested);
    on<FamilyRemoveMemberRequested>(_onFamilyRemoveMemberRequested);
    on<FamilyInviteMemberRequested>(_onFamilyInviteMemberRequested);
    on<CreateRewardRequested>(_onCreateRewardRequested);
    on<RedeemRewardRequested>(_onRedeemRewardRequested);
    on<FamilyPhotoUpdateRequested>(_onFamilyPhotoUpdateRequested);
    on<UpdateRewardRequested>(_onUpdateRewardRequested);
    on<GetRedemptionsRequested>(_onGetRedemptionsRequested);
    on<DeleteRewardRequested>(_onDeleteRewardRequested);
  }

  final FamilyRepository _familyRepository;
  final AuthenticationBloc _authenticationBloc;

  Future<void> _onFamilyRequested(
    FamilyRequested event,
    Emitter<FamilyState> emit,
  ) async {
    _authenticationBloc.add(AuthenticationUserRefreshed());
    emit(FamilyLoading());
    try {
      final user = await _familyRepository.getCurrentUser();
      if (user.familyId == null || user.familyId!.isEmpty) {
        emit(FamilyNoFamily());
      } else {
        final family = await _familyRepository.getFamilyById(user.familyId!);
        final members = await _familyRepository.fetchFamilyMembers(
          user.familyId!,
        );
        final rewards = await _familyRepository.getRewardsByFamilyID(
          user.familyId!,
        );
        final userPoints = await _familyRepository.getPoints(user.id);
        final redemptionHistory = await _familyRepository
            .getRedemptionsByUserID(user.id); // Получение истории

        emit(
          FamilyLoadSuccess(
            familyName: family.name,
            members: members,
            rewards: rewards,
            userPoints: userPoints,
            userName: user.name,
            redemptionHistory: redemptionHistory, // Передача истории
            familyPhotoUrl: family.photo, // Передача URL фотографии семьи
          ),
        );
      }
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onFamilyCreateRequested(
    FamilyCreateRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      await _familyRepository.createFamily(FamilyCreateInput(name: event.name));
      add(FamilyRequested());
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onFamilyJoinRequested(
    FamilyJoinRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      // TODO: Implement join family logic in FamilyRepository
      emit(FamilyLoadFailure(error: 'Join family method not implemented.'));
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onFamilyAddMemberRequested(
    FamilyAddMemberRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      final user = await _familyRepository.getCurrentUser();
      await _familyRepository.addMemberToFamily(
        InputAddMemberToFamily(
          emailUser: event.email,
          familyId: user.familyId!,
          role: event.role,
        ),
      );
      add(FamilyRequested());
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onFamilyRemoveMemberRequested(
    FamilyRemoveMemberRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      await _familyRepository.removeMemberFromFamily(
        event.memberId,
        event.familyId,
      );
      add(FamilyRequested()); // Обновляем список семьи после удаления
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onFamilyInviteMemberRequested(
    FamilyInviteMemberRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      final user = await _familyRepository.getCurrentUser();
      await _familyRepository.inviteMemberToFamily(
        InputAddMemberToFamily(
          emailUser: event.email,
          familyId: user.familyId!,
          role: event.role,
        ),
      );
      add(FamilyRequested()); // Обновляем данные семьи
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onCreateRewardRequested(
    CreateRewardRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(FamilyLoading());
    try {
      final user = await _familyRepository.getCurrentUser();
      if (user.familyId == null || user.familyId!.isEmpty) {
        throw Exception('User is not part of a family');
      }

      // Создание награды через репозиторий
      final output = await _familyRepository.createReward(event.input);
      print('Награда создана: $output'); // Отладочный вывод

      // Обновляем состояние семьи после создания награды
      add(FamilyRequested());
    } catch (e) {
      emit(
        FamilyLoadFailure(
          error:
              "_onCreateRewardRequested - Failed to create reward: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onRedeemRewardRequested(
    RedeemRewardRequested event,
    Emitter<FamilyState> emit,
  ) async {
    print('Redeeming reward with ID: ${event.rewardId}'); // Отладочный вывод
    try {
      emit(FamilyLoading()); // Переходим в состояние загрузки
      add(FamilyRequested());
      await _familyRepository.redeemReward(event.rewardId); // Обмен награды
      add(FamilyRequested()); // Обновляем данные семьи после обмена
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString())); // Обработка ошибок
    }
  }

  Future<void> _onFamilyPhotoUpdateRequested(
    FamilyPhotoUpdateRequested event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      emit(FamilyLoading());
      await _familyRepository.updateFamilyPhoto(event.familyId, event.photo);
      add(FamilyRequested()); // Обновляем данные семьи после загрузки фото
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onUpdateRewardRequested(
    UpdateRewardRequested event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      emit(FamilyLoading()); // Переход в состояние загрузки

      final user = await _familyRepository.getCurrentUser();
      if (user.familyId == null || user.familyId!.isEmpty) {
        throw Exception('User is not part of a family');
      }

      // Создаём объект RewardUpdateInput
      final input = RewardUpdateInput(
        familyId: user.familyId!,
        title: event.reward.title,
        description: event.reward.description,
        cost: event.reward.cost,
      );

      // Вызываем метод обновления награды в репозитории
      await _familyRepository.updateReward(input, event.reward.id);

      // Обновляем данные семьи после успешного обновления награды
      add(FamilyRequested());
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString())); // Обработка ошибок
    }
  }

  Future<void> _onGetRedemptionsRequested(
    GetRedemptionsRequested event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      // Сохраняем текущее состояние, если оно FamilyLoadSuccess
      final currentState = state;
      String? familyName;
      List<User>? members;
      List<Reward>? rewards;
      int? userPoints;
      String? userName;
      String? familyPhotoUrl;
      List<RewardRedemption> updatedRedemptions = [];

      if (currentState is FamilyLoadSuccess) {
        familyName = currentState.familyName;
        members = currentState.members;
        rewards = currentState.rewards;
        userPoints = currentState.userPoints;
        userName = currentState.userName;
        familyPhotoUrl = currentState.familyPhotoUrl;
        updatedRedemptions =
            currentState.redemptionHistory
                .where((redemption) => redemption.userId != event.userId)
                .toList(); // Удаляем старую историю для выбранного пользователя
      }

      emit(FamilyLoading()); // Переход в состояние загрузки

      // Загружаем новые данные
      final redemptions = await _familyRepository.getRedemptionsByUserIDParam(
        event.userId,
      );

      print('_onGetRedemptionsRequested – Полученные обмены: $redemptions');

      // Обновляем состояние с новой историей наград
      emit(
        FamilyLoadSuccess(
          familyName: familyName ?? '',
          members: members ?? [],
          rewards: rewards ?? [],
          userPoints: userPoints ?? 0,
          userName: userName ?? '',
          redemptionHistory: [
            ...updatedRedemptions, // Сохраняем историю других пользователей
            ...redemptions, // Добавляем обновлённую историю для выбранного пользователя
          ],
          familyPhotoUrl: familyPhotoUrl ?? '',
        ),
      );
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString())); // Обработка ошибок
    }
  }

  Future<void> _onDeleteRewardRequested(
    DeleteRewardRequested event,
    Emitter<FamilyState> emit,
  ) async {
    try {
      print('Deleting reward with ID: ${event.rewardId}'); // Отладочный вывод
      emit(FamilyLoading());
      await _familyRepository.deleteReward(event.rewardId);
      add(FamilyRequested()); // Обновляем данные семьи после удаления награды
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }
}
