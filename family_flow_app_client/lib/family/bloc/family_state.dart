part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyNoFamily extends FamilyState {}

class FamilyNoMembers extends FamilyState {}

class FamilyLoadSuccess extends FamilyState {
  const FamilyLoadSuccess({required this.members});

  final List<User> members;

  @override
  List<Object?> get props => [members];
}

class FamilyLoadFailure extends FamilyState {
  const FamilyLoadFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
