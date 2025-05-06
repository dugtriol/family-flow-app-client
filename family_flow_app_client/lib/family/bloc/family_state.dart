part of 'family_bloc.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

class FamilyInitial extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyNoFamily extends FamilyState {}

class FamilyNoMembers extends FamilyState {
  const FamilyNoMembers({required this.familyName});

  final String familyName;

  @override
  List<Object?> get props => [familyName];
}

class FamilyLoadSuccess extends FamilyState {
  const FamilyLoadSuccess({required this.familyName, required this.members});

  final String familyName;
  final List<User> members;

  @override
  List<Object> get props => [familyName, members];
}

class FamilyLoadFailure extends FamilyState {
  const FamilyLoadFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
