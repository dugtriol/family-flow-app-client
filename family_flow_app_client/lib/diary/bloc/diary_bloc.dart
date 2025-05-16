import 'package:bloc/bloc.dart';
import 'package:diary_api/diary_api.dart' show DiaryItem;
import 'package:equatable/equatable.dart';
import 'package:diary_repository/diary_repository.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryRepository _diaryRepository;

  DiaryBloc({required DiaryRepository diaryRepository})
    : _diaryRepository = diaryRepository,
      super(DiaryLoading()) {
    on<DiaryRequested>(_onDiaryRequested);
    on<DiaryEntryAdded>(_onDiaryEntryAdded);
    on<DiaryEntryUpdated>(_onDiaryEntryUpdated);
    on<DiaryEntryDeleted>(_onDiaryEntryDeleted);
  }
  Future<void> _onDiaryRequested(
    DiaryRequested event,
    Emitter<DiaryState> emit,
  ) async {
    emit(DiaryLoading());
    print('DiaryRequested event received');
    try {
      final entries = await _diaryRepository.fetchDiaryEntries();
      print('Diary entries loaded: $entries');
      emit(DiaryLoadSuccess(entries: entries));
    } catch (e) {
      print('DiaryRequested - Error: $e');
      emit(DiaryLoadFailure(error: e.toString()));
    }
  }

  Future<void> _onDiaryEntryAdded(
    DiaryEntryAdded event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoadSuccess) {
      try {
        await _diaryRepository.createDiaryEntry(
          title: event.entry.title,
          description: event.entry.description,
          emoji: event.entry.emoji,
        );
        final updatedEntries = await _diaryRepository.fetchDiaryEntries();
        emit(DiaryLoadSuccess(entries: updatedEntries));
      } catch (e) {
        emit(DiaryLoadFailure(error: e.toString()));
      }
    }
  }

  Future<void> _onDiaryEntryUpdated(
    DiaryEntryUpdated event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoadSuccess) {
      try {
        await _diaryRepository.updateDiaryEntry(
          id: event.oldEntry.id,
          title: event.updatedEntry.title,
          description: event.updatedEntry.description,
          emoji: event.updatedEntry.emoji,
        );
        final updatedEntries = await _diaryRepository.fetchDiaryEntries();
        emit(DiaryLoadSuccess(entries: updatedEntries));
      } catch (e) {
        emit(DiaryLoadFailure(error: e.toString()));
      }
    }
  }

  Future<void> _onDiaryEntryDeleted(
    DiaryEntryDeleted event,
    Emitter<DiaryState> emit,
  ) async {
    if (state is DiaryLoadSuccess) {
      try {
        await _diaryRepository.deleteDiaryEntry(event.entry.id);
        final updatedEntries = await _diaryRepository.fetchDiaryEntries();
        emit(DiaryLoadSuccess(entries: updatedEntries));
      } catch (e) {
        emit(DiaryLoadFailure(error: e.toString()));
      }
    }
  }
}
