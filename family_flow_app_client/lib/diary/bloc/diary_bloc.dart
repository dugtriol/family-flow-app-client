import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  DiaryBloc() : super(DiaryLoading()) {
    on<DiaryRequested>(_onDiaryRequested);
  }

  Future<void> _onDiaryRequested(
      DiaryRequested event, Emitter<DiaryState> emit) async {
    try {
      // Заглушка для загрузки данных дневника
      await Future.delayed(const Duration(seconds: 1));
      emit(DiaryLoadSuccess(entries: [
        DiaryEntry(title: 'Запись 1', content: 'Содержание записи 1'),
        DiaryEntry(title: 'Запись 2', content: 'Содержание записи 2'),
      ]));
    } catch (e) {
      emit(DiaryLoadFailure(error: e.toString()));
    }
  }
}
