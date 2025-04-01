enum TaskStatus { active, completed, overdue, createdBy }

extension TaskStatusExtension on TaskStatus {
  String get name {
    switch (this) {
      case TaskStatus.active:
        return 'active';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.overdue:
        return 'overdue';
      case TaskStatus.createdBy:
        return 'createdBy';
    }
  }
}
