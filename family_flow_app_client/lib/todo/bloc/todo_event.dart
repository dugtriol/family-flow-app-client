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

class TodoUpdateCompleteRequested extends TodoEvent {
  const TodoUpdateCompleteRequested({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime deadline;
  final String assignedTo;

  @override
  List<Object> get props =>
      [id, title, description, status, deadline, assignedTo];
}

class TodoUpdateRequested extends TodoEvent {
  const TodoUpdateRequested({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.deadline,
    required this.assignedTo,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime deadline;
  final String assignedTo;

  @override
  List<Object> get props =>
      [id, title, description, status, deadline, assignedTo];
}

class TodoDeleteRequested extends TodoEvent {
  const TodoDeleteRequested({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
