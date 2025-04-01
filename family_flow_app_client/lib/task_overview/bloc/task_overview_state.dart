part of 'task_overview_bloc.dart';

abstract class TaskOverviewState extends Equatable {
  const TaskOverviewState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние
class TaskOverviewInitial extends TaskOverviewState {}

/// Состояние загрузки задач
class TaskOverviewLoadInProgress extends TaskOverviewState {}

/// Состояние успешной загрузки задач
class TaskOverviewLoadSuccess extends TaskOverviewState {
  const TaskOverviewLoadSuccess({required this.tasks});

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}

/// Состояние ошибки при загрузке задач
class TaskOverviewLoadFailure extends TaskOverviewState {
  const TaskOverviewLoadFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
