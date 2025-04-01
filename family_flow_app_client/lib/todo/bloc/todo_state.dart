part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoadSuccess extends TodoState {
  const TodoLoadSuccess(this.todos);

  final List<TodoItem> todos;

  @override
  List<Object> get props => [todos];
}

class TodoLoadFailure extends TodoState {}
