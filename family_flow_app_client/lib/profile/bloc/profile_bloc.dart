import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_flow_app_client/authentication/bloc/authentication_bloc.dart';
import 'package:family_flow_app_client/family/family.dart';
import 'package:family_repository/family_repository.dart';
import 'package:user_repository/user_repository.dart' show User;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthenticationBloc authenticationBloc,
    required FamilyBloc familyBloc,
  }) : _authenticationBloc = authenticationBloc,
       _familyBloc = familyBloc,
       super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
    on<ProfileLogoutRequested>(_onLogoutRequested);
    on<ProfileReset>(_onReset);
  }

  final AuthenticationBloc _authenticationBloc;
  final FamilyBloc _familyBloc;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    print('ProfileRequested event received');
    final user = _authenticationBloc.state.user;
    if (user != null) {
      print('User found: ${user.id}');
      try {
        String? familyName;
        if (user.familyId.isNotEmpty) {
          print('Fetching family data for familyId: ${user.familyId}');
          // Получаем состояние FamilyBloc
          final familyState = _familyBloc.state;
          if (familyState is FamilyLoadSuccess) {
            final family = familyState.members.firstWhere(
              (member) => member.id == user.familyId,
              orElse: () => User.empty,
            );
            familyName = family?.name;
            print('Family data fetched successfully: $familyName');
          } else {
            print('Family data not loaded yet');
          }
        }
        emit(ProfileLoadSuccess(user: user, familyName: familyName));
        print('ProfileLoadSuccess emitted');
      } catch (e) {
        print('Error fetching family data: $e');
        emit(const ProfileLoadFailure(error: 'Failed to load family data.'));
      }
    } else {
      print('User not found in authentication state');
      emit(const ProfileLoadFailure(error: 'User not found.'));
    }
  }

  void _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) {
    _authenticationBloc.add(AuthenticationLogoutPressed());
  }

  void _onReset(ProfileReset event, Emitter<ProfileState> emit) {
    emit(ProfileInitial());
  }
}
