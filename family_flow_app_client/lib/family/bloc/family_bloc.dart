import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_api/family_api.dart';
import 'package:family_repository/family_repository.dart'; // Ensure this is the correct path
import 'package:user_repository/user_repository.dart';

part 'family_event.dart';
part 'family_state.dart';

class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyBloc({
    required FamilyRepository familyRepository,
  })  : _familyRepository = familyRepository,
        super(FamilyInitial()) {
    on<FamilyRequested>(_onFamilyRequested);
    on<FamilyCreateRequested>(_onFamilyCreateRequested);
    on<FamilyJoinRequested>(_onFamilyJoinRequested);
    on<FamilyAddMemberRequested>(_onFamilyAddMemberRequested);
  }

  final FamilyRepository _familyRepository;

Future<void> _onFamilyRequested(
  FamilyRequested event,
  Emitter<FamilyState> emit,
) async {
  emit(FamilyLoading());
  try {
    final user = await _familyRepository.getCurrentUser();
    if (user.familyId.isEmpty) {
      emit(FamilyNoFamily());
    } else {
      final family = await _familyRepository.getFamilyById(user.familyId);
      final members = await _familyRepository.fetchFamilyMembers(user.familyId);

      if (members.isEmpty) {
        emit(FamilyNoMembers(familyName: family.name));
      } else {
        emit(FamilyLoadSuccess(familyName: family.name, members: members));
      }
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
        InputAddMemberToFamily(emailUser: event.email, familyId: user.familyId),
      );
      add(FamilyRequested());
    } catch (e) {
      emit(FamilyLoadFailure(error: e.toString()));
    }
  }
}
