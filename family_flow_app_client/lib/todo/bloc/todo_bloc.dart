import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_flow_app_client/app/view/notification_service.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({required TodoRepository todoRepository})
    : _todoRepository = todoRepository,
      super(TodoInitial()) {
    on<TodoAssignedToRequested>(_onAssignedToRequested);
    on<TodoCreatedByRequested>(_onCreatedByRequested);
    on<TodoCreateRequested>(_onCreateRequested);
    on<TodoUpdateCompleteRequested>(_onUpdateCompleteRequested);
    on<TodoUpdateRequested>(_onUpdateRequested);
    on<TodoDeleteRequested>(_onDeleteRequested);
  }

  final TodoRepository _todoRepository;

  Future<void> _onAssignedToRequested(
    TodoAssignedToRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();

      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onCreatedByRequested(
    TodoCreatedByRequested event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.fetchTodosCreatedByCurrentUser();
      print('Созданные мной задачи: $todos'); // Отладочный вывод
      emit(TodoCreatedByLoadSuccess(todos));
    } catch (error) {
      print('Ошибка загрузки созданных задач: $error'); // Отладочный вывод
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onCreateRequested(
    TodoCreateRequested event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());
      await _todoRepository.createTodo(
        title: event.title,
        description: event.description,
        assignedTo: event.assignedTo,
        deadline: event.deadline,
        point: event.point,
      );
      // Обновляем список задач
      await _onAssignedToRequested(TodoAssignedToRequested(), emit);
      await _onCreatedByRequested(TodoCreatedByRequested(), emit);
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onUpdateCompleteRequested(
    TodoUpdateCompleteRequested event,
    Emitter<TodoState> emit,
  ) async {
    try {
      print(
        'Обработка события TodoUpdateCompleteRequested для задачи: ${event.title}',
      );
      emit(TodoLoading());
      await _todoRepository.updateTodo(
        id: event.id,
        title: event.title,
        description: event.description,
        status: "Completed",
        assignedTo: event.assignedTo,
        deadline: event.deadline,
        point: event.point,
      );

      print('Задача "${event.title}" успешно завершена!'); // Отладочный вывод
      await NotificationService().showNotification(
        id: event.id.hashCode,
        title: 'Задача завершена',
        body: 'Задача "${event.title}" успешно завершена!',
      );
      // Обновляем список задач
      await _onAssignedToRequested(TodoAssignedToRequested(), emit);
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onUpdateRequested(
    TodoUpdateRequested event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());
      await _todoRepository.updateTodo(
        id: event.id,
        title: event.title,
        description: event.description,
        status: event.status,
        assignedTo: event.assignedTo,
        deadline: event.deadline,
        point: event.point,
      );
      // Обновляем список задач
      await _onAssignedToRequested(TodoAssignedToRequested(), emit);
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onDeleteRequested(
    TodoDeleteRequested event,
    Emitter<TodoState> emit,
  ) async {
    try {
      emit(TodoLoading());
      await _todoRepository.deleteTodo(id: event.id);
      // Обновляем список задач
      await _onAssignedToRequested(TodoAssignedToRequested(), emit);
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }
}
