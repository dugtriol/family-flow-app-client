import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/models.dart';

class TaskCreateFailure implements Exception {}

class TaskApiClient {
  TaskApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'http://10.0.2.2:8080/api';
  final http.Client _httpClient;

  Future<String> createTask(TaskCreate task, String token) async {
    print('createTask called with task: ${task.toJson()}');
    final uri = Uri.parse('$_baseUrl/task');
    print('Constructed URI: $uri');

    final jsonen = jsonEncode(task.toJson());
    print('jsonen: $jsonen');
    print('token: $token');
    final response = await _httpClient.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonen,
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing TaskCreateFailure.');
      print('Response body: ${response.body}');
      throw TaskCreateFailure();
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    print('Response body decoded: $responseBody');
    final taskId = responseBody['id'] as String;
    print('Task ID created: $taskId');
    return taskId;
  }

  Future<TaskGetOutputList> getTasks(TaskGetInput input, String token) async {
    print('getTasks called with input: ${input.toJson()}');
    final uri = Uri.parse('$_baseUrl/task');
    print('Constructed URI: $uri');

    final response = await _httpClient.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response received with status code: ${response.statusCode}');

    if (response.statusCode != 200) {
      print('Response status code is not 200. Throwing exception.');
      throw Exception('Failed to fetch tasks');
    }

    final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
    print('Response body decoded: $responseBody');
    return TaskGetOutputList.fromJson(responseBody);
  }

  void close() {
    _httpClient.close();
  }
}
