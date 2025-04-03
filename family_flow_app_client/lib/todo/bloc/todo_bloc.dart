import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      TodoAssignedToRequested event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();
      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onCreatedByRequested(
      TodoCreatedByRequested event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.fetchTodosCreatedByCurrentUser();
      emit(TodoCreatedByLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onCreateRequested(
      TodoCreateRequested event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.createTodo(
        title: event.title,
        description: event.description,
        assignedTo: event.assignedTo,
        deadline: event.deadline,
      );
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();
      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onUpdateCompleteRequested(
      TodoUpdateCompleteRequested event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.updateTodo(
        id: event.id,
        title: event.title,
        description: event.description,
        status: "Completed",
        assignedTo: event.assignedTo,
        deadline: event.deadline,
      );
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();
      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onUpdateRequested(
      TodoUpdateRequested event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.updateTodo(
        id: event.id,
        title: event.title,
        description: event.description,
        status: event.status,
        assignedTo: event.assignedTo,
        deadline: event.deadline,
      );
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();
      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }

  Future<void> _onDeleteRequested(
      TodoDeleteRequested event, Emitter<TodoState> emit) async {
    try {
      emit(TodoLoading());
      await _todoRepository.deleteTodo(id: event.id);
      final todos = await _todoRepository.fetchTodosAssignedToCurrentUser();
      emit(TodoAssignedToLoadSuccess(todos));
    } catch (_) {
      emit(TodoLoadFailure());
    }
  }
}
