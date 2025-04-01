import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_api/todo_api.dart';

class TodoRepository {
  TodoRepository({TodoApiClient? todoApiClient})
      : _todoApiClient = todoApiClient ?? TodoApiClient();

  final TodoApiClient _todoApiClient;
  final _controller = StreamController<List<TodoItem>>();
  String? _familyId; // Поле для хранения familyId

  Stream<List<TodoItem>> get todos async* {
    try {
      final todoList = await fetchTodosAssignedToCurrentUser();
      yield todoList;
      yield* _controller.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Метод для обновления familyId
  void updateFamilyId(String? familyId) {
    _familyId = familyId;
    print('Family ID updated: $_familyId');
  }

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Создание задачи
  Future<String> createTodo({
    required String title,
    required String description,
    required String assignedTo,
    required DateTime deadline,
  }) async {
    try {
      print('Starting to create a new todo...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      if (_familyId == null) {
        print('Family ID is missing');
        throw Exception('Family ID is missing');
      }

      final todoCreateInput = TodoCreateInput(
        familyId: _familyId!,
        title: title,
        description: description,
        deadline: deadline,
        assignedTo: assignedTo,
      );
      print('TodoCreateInput prepared: $todoCreateInput');

      final todoId = await _todoApiClient.createTodo(todoCreateInput, token);
      print('Todo created successfully with ID: $todoId');

      final updatedTodos = await fetchTodosAssignedToCurrentUser();
      print('Updated todos fetched: $updatedTodos');
      _controller.add(updatedTodos);

      return todoId;
    } catch (e) {
      print('Failed to create todo: $e');
      throw TodoCreateFailure();
    }
  }

  /// Получение задач, назначенных текущему пользователю
  Future<List<TodoItem>> fetchTodosAssignedToCurrentUser() async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _todoApiClient.getTodosAssignedTo(token);
    } catch (_) {
      throw Exception('Failed to fetch todos assigned to the current user');
    }
  }

  /// Получение задач, созданных текущим пользователем
  Future<List<TodoItem>> fetchTodosCreatedByCurrentUser() async {
    try {
      final token = await _getJwtToken();
      if (token == null) {
        throw Exception('JWT token is missing');
      }

      return await _todoApiClient.getTodosCreatedBy(token);
    } catch (_) {
      throw Exception('Failed to fetch todos created by the current user');
    }
  }

  void dispose() => _controller.close();
}
