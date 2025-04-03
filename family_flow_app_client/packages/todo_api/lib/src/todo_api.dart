// filepath: /Users/aimandzhi/VScodeProjects/family-flow-app-client/family_flow_app_client/packages/todo_api/lib/src/todo_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_api/src/models/models.dart';

class TodoCreateFailure implements Exception {}

class TodoApiClient {
  TodoApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://localhost:8080/api';
  final http.Client _httpClient;

  /// Method to create a todo item
  Future<String> createTodo(TodoCreateInput input, String token) async {
    print('createTodo called with input: ${input.toJson()}');
    final uri = Uri.parse('$_baseUrl/todo');
    print('Constructed URI: $uri');

    final jsonBody = jsonEncode(input.toJson());
    print('JSON body: $jsonBody');
    print('Token: $token');

    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 201) {
      print('Response status code is not 201. Throwing TodoCreateFailure.');
      print('Response body: ${response.body}');
      throw TodoCreateFailure();
    }

    final responseBody = jsonDecode(response.body) as String;
    print('Todo created successfully: $responseBody');
    return responseBody;
  }

  /// Method to get todos assigned to a specific user
  Future<List<TodoItem>> getTodosAssignedTo(String token) async {
    final uri = Uri.parse('$_baseUrl/todo/assigned_to');
    print('Constructed URI for getTodosAssignedTo: $uri');
    print('Token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch todos assigned to user');
    }

    final responseBody = jsonDecode(response.body) as List;
    print('Todos fetched successfully: $responseBody');
    return responseBody.map((json) => TodoItem.fromJson(json)).toList();
  }

  /// Method to get todos created by a specific user
  Future<List<TodoItem>> getTodosCreatedBy(String token) async {
    final uri = Uri.parse('$_baseUrl/todo/created_by');
    print('Constructed URI for getTodosCreatedBy: $uri');
    print('Token: $token');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch todos created by user');
    }

    final responseBody = jsonDecode(response.body) as List;
    print('Todos fetched successfully: $responseBody');
    return responseBody.map((json) => TodoItem.fromJson(json)).toList();
  }

  /// Method to update a todo item
  Future<String> updateTodo(
    String id,
    InputTodoUpdate input,
    String token,
  ) async {
    final uri = Uri.parse('$_baseUrl/todo/$id');
    print('Constructed URI for updateTodo: $uri');
    print('Token: $token');
    print('Update input: ${input.toJson()}');

    final jsonBody = jsonEncode(input.toJson());
    print('JSON body: $jsonBody');

    final response = await _httpClient.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonBody,
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to update todo');
    }

    final responseBody = jsonDecode(response.body) as String;
    print('Todo updated successfully: $responseBody');
    return responseBody;
  }

  /// Method to delete a todo item
  Future<String> deleteTodo(String id, String token) async {
    final uri = Uri.parse('$_baseUrl/todo/$id');
    print('Constructed URI for deleteTodo: $uri');
    print('Token: $token');

    final response = await _httpClient.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing Exception.');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete todo');
    }

    final responseBody = jsonDecode(response.body) as String;
    print('Todo deleted successfully: $responseBody');
    return responseBody;
  }

  void close() {
    _httpClient.close();
  }
}
