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
  final String email;
  final String role;

  const FamilyAddMemberRequested({required this.email, required this.role});

  @override
  List<Object> get props => [email, role];
}

class FamilyRemoveMemberRequested extends FamilyEvent {
  final String memberId;
  final String familyId;

  const FamilyRemoveMemberRequested({
    required this.memberId,
    required this.familyId,
  });

  @override
  List<Object> get props => [memberId, familyId];
}

class FamilyInviteMemberRequested extends FamilyEvent {
  final String email;
  final String role;

  const FamilyInviteMemberRequested({required this.email, required this.role});

  @override
  List<Object> get props => [email, role];
}

class LoadFamily extends FamilyEvent {}

class CreateRewardRequested extends FamilyEvent {
  final RewardCreateInput input;

  const CreateRewardRequested({required this.input});

  @override
  List<Object?> get props => [input];
}

class RedeemRewardRequested extends FamilyEvent {
  final String rewardId;

  const RedeemRewardRequested({required this.rewardId});

  @override
  List<Object?> get props => [rewardId];
}

class UpdateRewardRequested extends FamilyEvent {
  final Reward reward;

  const UpdateRewardRequested(this.reward);

  @override
  List<Object> get props => [reward];
}

class GetRedemptionsRequested extends FamilyEvent {
  final String userId;

  const GetRedemptionsRequested(this.userId);

  @override
  List<Object> get props => [userId];
}

class DeleteRewardRequested extends FamilyEvent {
  final String rewardId;

  const DeleteRewardRequested(this.rewardId);

  @override
  List<Object> get props => [rewardId];
}
