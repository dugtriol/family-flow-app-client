import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/task_repository.dart';

part 'task_overview_event.dart';
part 'task_overview_state.dart';

class TaskOverviewBloc extends Bloc<TaskOverviewEvent, TaskOverviewState> {
  TaskOverviewBloc({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(TaskOverviewInitial()) {
    on<TaskOverviewTasksRequested>(_onTasksRequested);
    on<TaskOverviewTaskCreated>(_onTaskCreated);
  }

  final TaskRepository _taskRepository;

  Future<void> _onTasksRequested(
    TaskOverviewTasksRequested event,
    Emitter<TaskOverviewState> emit,
  ) async {
    emit(TaskOverviewLoadInProgress());
    try {
      final tasks = await _taskRepository.fetchTasks();
      emit(TaskOverviewLoadSuccess(tasks: tasks));
    } catch (e) {
      emit(TaskOverviewLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onTaskCreated(
    TaskOverviewTaskCreated event,
    Emitter<TaskOverviewState> emit,
  ) async {
    try {
      await _taskRepository.createTaskFromStrings(
        title: event.title,
        description: event.description,
        deadline: event.deadline,
        assignedTo: event.assignedTo,
        reward: event.reward,
      );
      // После создания задачи обновляем список задач
      add(TaskOverviewTasksRequested());
    } catch (e) {
      emit(TaskOverviewLoadFailure(error: e.toString()));
    }
  }
}
