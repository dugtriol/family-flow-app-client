part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object> get props => [];
}

class DiaryLoading extends DiaryState {}

class DiaryLoadSuccess extends DiaryState {
  final List<DiaryItem> entries;

  const DiaryLoadSuccess({required this.entries});

  @override
  List<Object> get props => [entries];
}

class DiaryLoadFailure extends DiaryState {
  final String error;

  const DiaryLoadFailure({required this.error});

  @override
  List<Object> get props => [error];
}
