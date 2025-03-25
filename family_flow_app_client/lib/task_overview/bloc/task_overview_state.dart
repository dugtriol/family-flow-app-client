part of 'task_overview_bloc.dart';

abstract class TaskOverviewState extends Equatable {
  const TaskOverviewState();

  @override
  List<Object> get props => [];
}

/// Начальное состояние
class TaskOverviewInitial extends TaskOverviewState {}

/// Состояние, когда происходит выход из приложения
class TaskOverviewLogoutInProgress extends TaskOverviewState {}

/// Состояние, когда выход завершен
class TaskOverviewLogoutSuccess extends TaskOverviewState {}
