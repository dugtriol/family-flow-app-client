import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diary_api/diary_api.dart';

class DiaryRepository {
  DiaryRepository({DiaryApi? diaryApi}) : _diaryApi = diaryApi ?? DiaryApi();

  final DiaryApi _diaryApi;
  final _diaryController = StreamController<List<DiaryItem>>();
  String? _userId;

  /// Поток для записей дневника
  Stream<List<DiaryItem>> get diaryEntries async* {
    try {
      print('Fetching diary entries...');
      final entries = await fetchDiaryEntries();
      yield entries;
      yield* _diaryController.stream;
    } catch (_) {
      yield [];
    }
  }

  /// Получение JWT-токена из SharedPreferences
  Future<String?> _getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Получение записей дневника
  Future<List<DiaryItem>> fetchDiaryEntries() async {
    try {
      print('Fetching diary entries...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }
      print('JWT token retrieved: $token');

      final entries = await _diaryApi.getDiaryEntries(token);
      print('Diary entries fetched successfully: $entries');
      return entries;
    } catch (e) {
      print(
        'DiaryRepository - fetchDiaryEntries - Failed to fetch diary entries: $e',
      );
      throw Exception('Failed to fetch diary entries');
    }
  }

  /// Создание записи в дневнике
  Future<String> createDiaryEntry({
    required String title,
    required String description,
    required String emoji,
  }) async {
    try {
      print('Starting to create a new diary entry...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      final diaryCreateInput = DiaryCreateInput(
        title: title,
        description: description,
        emoji: emoji,
      );
      print('DiaryCreateInput prepared: $diaryCreateInput');

      final diaryEntryId = await _diaryApi.createDiaryEntry(
        diaryCreateInput,
        token,
      );
      print('Diary entry created successfully with ID: $diaryEntryId');

      final updatedDiaryEntries = await fetchDiaryEntries();
      print('Updated diary entries fetched: $updatedDiaryEntries');
      _diaryController.add(updatedDiaryEntries);

      return diaryEntryId;
    } catch (e) {
      print('Failed to create diary entry: $e');
      throw Exception('Failed to create diary entry');
    }
  }

  /// Обновление записи в дневнике
  Future<void> updateDiaryEntry({
    required String id,
    required String title,
    required String description,
    required String emoji,
  }) async {
    try {
      print('Starting to update a diary entry...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      final diaryUpdateInput = DiaryUpdateInput(
        title: title,
        description: description,
        emoji: emoji,
      );
      print('DiaryUpdateInput prepared: $diaryUpdateInput');

      await _diaryApi.updateDiaryEntry(id, diaryUpdateInput, token);
      print('Diary entry updated successfully');

      final updatedDiaryEntries = await fetchDiaryEntries();
      print('Updated diary entries fetched: $updatedDiaryEntries');
      _diaryController.add(updatedDiaryEntries);
    } catch (e) {
      print('Failed to update diary entry: $e');
      throw Exception('Failed to update diary entry');
    }
  }

  /// Удаление записи в дневнике
  Future<void> deleteDiaryEntry(String id) async {
    try {
      print('Starting to delete a diary entry...');
      final token = await _getJwtToken();
      if (token == null) {
        print('JWT token is missing');
        throw Exception('JWT token is missing');
      }

      await _diaryApi.deleteDiaryEntry(id, token);
      print('Diary entry deleted successfully');

      final updatedDiaryEntries = await fetchDiaryEntries();
      print('Updated diary entries fetched: $updatedDiaryEntries');
      _diaryController.add(updatedDiaryEntries);
    } catch (e) {
      print('Failed to delete diary entry: $e');
      throw Exception('Failed to delete diary entry');
    }
  }

  void dispose() {
    _diaryController.close();
  }
}
