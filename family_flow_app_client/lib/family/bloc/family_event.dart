part of 'family_bloc.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object?> get props => [];
}

class FamilyRequested extends FamilyEvent {}

class FamilyCreateRequested extends FamilyEvent {
  const FamilyCreateRequested({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class FamilyJoinRequested extends FamilyEvent {
  const FamilyJoinRequested({required this.familyId});

  final String familyId;

  @override
  List<Object?> get props => [familyId];
}

class FamilyAddMemberRequested extends FamilyEvent {
  const FamilyAddMemberRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
