part of 'task_overview_bloc.dart';

abstract class TaskOverviewEvent extends Equatable {
  const TaskOverviewEvent();

  @override
  List<Object> get props => [];
}

/// Событие для запроса выхода из приложения
class TaskOverviewLogoutRequested extends TaskOverviewEvent {}
