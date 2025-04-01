import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_api/task_api.dart';
import 'package:task_repository/src/task_status.dart';

import 'models/task.dart';

class TaskRepository {
  TaskRepository({TaskApiClient? taskApiClient})
      : _taskApiClient = taskApiClient ?? TaskApiClient();

  final TaskApiClient _taskApiClient;
  final _controller = StreamController<List<Task>>();

  Stream<List<Task>> get tasks async* {
    try {
      final taskList = await fetchTasks();
      yield taskList;
      yield* _controller.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createTaskFromStrings({
    required String title,
    required String description,
    required DateTime deadline,
    required String assignedTo,
    required int reward,
  }) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      final taskCreateInput = TaskCreate(
        title: title,
        description: description,
        deadline: deadline,
        assignedTo: assignedTo,
        reward: reward,
      );
      await _taskApiClient.createTask(taskCreateInput, token);
      final updatedTasks = await fetchTasks();
      _controller.add(updatedTasks);
    } catch (_) {
      throw TaskCreateFailure();
    }
  }

  Future<List<Task>> fetchTasks({TaskStatus status = TaskStatus.active}) async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      print('Fetching tasks with status: ${status.name}');
      final input = TaskGetInput(status: status.name);
      final taskOutputList = await _taskApiClient.getTasks(input, token);
      print('Fetched ${taskOutputList.tasks.length} tasks');
      return taskOutputList.tasks
          .map((task) => Task.fromTaskOutput(task))
          .toList();
    } catch (e) {
      print('Failed to fetch tasks: $e');
      throw Exception('Failed to fetch tasks');
    }
  }

  void dispose() => _controller.close();
}
