import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

class DiaryApi {
  // static const _baseUrl = 'http://10.0.2.2:8080/api/diary';
  // static const _baseUrl = 'http://family-flow-app-aigul.amvera.io/api';
  static const _baseUrl = 'http://family-flow-app-1-aigul.amvera.io/api/diary';
  final http.Client _httpClient;

  DiaryApi({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Создание записи в дневнике
  Future<String> createDiaryEntry(DiaryCreateInput input, String token) async {
    final response = await _httpClient.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to create diary entry: ${response.body}');
    }
  }

  /// Получение записей дневника по ID пользователя
  Future<List<DiaryItem>> getDiaryEntries(String token) async {
    final response = await _httpClient.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
      if (responseBody == null || responseBody is! List) {
        print(
          'getDiaryEntries - API вернул null или некорректный формат. Возвращаем пустой список.',
        );
        return []; // Возвращаем пустой список
      }
      return (responseBody as List)
          .map((json) => DiaryItem.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch diary entries: ${response.body}');
    }
  }

  /// Обновление записи в дневнике
  Future<void> updateDiaryEntry(
    String id,
    DiaryUpdateInput input,
    String token,
  ) async {
    final response = await _httpClient.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(input.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update diary entry: ${response.body}');
    }
  }

  /// Удаление записи в дневнике
  Future<void> deleteDiaryEntry(String id, String token) async {
    final response = await _httpClient.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete diary entry: ${response.body}');
    }
  }
}
