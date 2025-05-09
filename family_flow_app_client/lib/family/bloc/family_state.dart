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
  const FamilyLoadSuccess({
    required this.familyName,
    required this.members,
    required this.rewards,
    required this.userPoints,
    required this.userName,
    required this.redemptionHistory, // Добавлено
    this.familyPhotoUrl,
  });

  final String familyName;
  final List<User> members;
  final List<Reward> rewards;
  final int userPoints;
  final String userName;
  final List<RewardRedemption> redemptionHistory; // История обменов
  final String? familyPhotoUrl; // URL фотографии семьи

  @override
  List<Object> get props => [
    familyName,
    members,
    rewards,
    userPoints,
    userName,
    redemptionHistory,
    familyPhotoUrl ?? '', // Используем пустую строку, если URL отсутствует
  ];
}

class FamilyLoadFailure extends FamilyState {
  const FamilyLoadFailure({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

class FamilyPhotoUpdateRequested extends FamilyEvent {
  final String familyId;
  final File photo;

  FamilyPhotoUpdateRequested({required this.familyId, required this.photo});

  @override
  List<Object> get props => [familyId, photo];
}
