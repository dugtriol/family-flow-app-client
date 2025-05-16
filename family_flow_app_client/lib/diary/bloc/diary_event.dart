part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

class DiaryRequested extends DiaryEvent {}

class DiaryEntryAdded extends DiaryEvent {
  final DiaryItem entry;

  const DiaryEntryAdded(this.entry);

  @override
  List<Object> get props => [entry];
}

class DiaryEntryUpdated extends DiaryEvent {
  final DiaryItem oldEntry;
  final DiaryItem updatedEntry;

  const DiaryEntryUpdated({required this.oldEntry, required this.updatedEntry});

  @override
  List<Object> get props => [oldEntry, updatedEntry];
}

class DiaryEntryDeleted extends DiaryEvent {
  final DiaryItem entry;

  const DiaryEntryDeleted(this.entry);

  @override
  List<Object> get props => [entry];
}
