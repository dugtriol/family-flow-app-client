part of 'task_overview_bloc.dart';

abstract class TaskOverviewEvent extends Equatable {
  const TaskOverviewEvent();

  @override
  List<Object?> get props => [];
}

/// Событие для запроса списка задач
class TaskOverviewTasksRequested extends TaskOverviewEvent {}

/// Событие для создания новой задачи
class TaskOverviewTaskCreated extends TaskOverviewEvent {
  const TaskOverviewTaskCreated({
    required this.title,
    required this.description,
    required this.deadline,
    required this.assignedTo,
    required this.reward,
  });

  final String title;
  final String description;
  final DateTime deadline;
  final String assignedTo;
  final int reward;

  @override
  List<Object?> get props => [title, description, deadline, assignedTo, reward];
}
