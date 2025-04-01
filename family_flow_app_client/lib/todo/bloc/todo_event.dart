part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class TodoAssignedToRequested extends TodoEvent {}

class TodoCreatedByRequested extends TodoEvent {}

class TodoCreateRequested extends TodoEvent {
  const TodoCreateRequested({
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.deadline,
  });
  final String title;
  final String description;
  final String assignedTo;
  final DateTime deadline;

  @override
  List<Object> get props => [title, description, assignedTo, deadline];
}
