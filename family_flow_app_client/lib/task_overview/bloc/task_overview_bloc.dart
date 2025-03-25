import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:authentication_repository/authentication_repository.dart';

part 'task_overview_event.dart';
part 'task_overview_state.dart';

class TaskOverviewBloc extends Bloc<TaskOverviewEvent, TaskOverviewState> {
  TaskOverviewBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(TaskOverviewInitial()) {
    on<TaskOverviewLogoutRequested>(_onLogoutRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  /// Обработчик события выхода
  Future<void> _onLogoutRequested(
    TaskOverviewLogoutRequested event,
    Emitter<TaskOverviewState> emit,
  ) async {
    emit(TaskOverviewLogoutInProgress());
    _authenticationRepository.logOut();
    emit(TaskOverviewLogoutSuccess());
  }
}
