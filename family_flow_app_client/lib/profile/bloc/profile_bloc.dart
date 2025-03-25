import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_flow_app_client/authentication/bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart' show User;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required AuthenticationBloc authenticationBloc,
  })  : _authenticationBloc = authenticationBloc,
        super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  final AuthenticationBloc _authenticationBloc;

  void _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) {
    final user = _authenticationBloc.state.user;
    if (user != null) {
      emit(ProfileLoadSuccess(user: user));
    } else {
      emit(const ProfileLoadFailure(error: 'User not found.'));
    }
  }
}
