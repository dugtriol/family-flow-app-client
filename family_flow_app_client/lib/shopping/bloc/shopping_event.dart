part of 'shopping_bloc.dart';

abstract class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

class ShoppingListRequested extends ShoppingEvent {}

class ShoppingItemCreateRequested extends ShoppingEvent {
  const ShoppingItemCreateRequested({
    required this.title,
    required this.description,
    required this.visibility,
  });

  final String title;
  final String description;
  final String visibility;

  @override
  List<Object> get props => [title, description, visibility];
}

class ShoppingTypeChanged extends ShoppingEvent {
  const ShoppingTypeChanged(this.isPublic);

  final bool isPublic; // true для public, false для private

  @override
  List<Object> get props => [isPublic];
}

class ShoppingItemStatusUpdated extends ShoppingEvent {
  final String id;
  final String title;
  final String description;
  final String status;
  final String visibility;
  final bool isArchived;

  const ShoppingItemStatusUpdated({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.visibility,
    required this.isArchived,
  });

  @override
  List<Object> get props => [
    id,
    title,
    description,
    status,
    visibility,
    isArchived,
  ];
}

class ShoppingItemDeleted extends ShoppingEvent {
  final String id;

  const ShoppingItemDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

class ShoppingItemReserved extends ShoppingEvent {
  final String id;
  final String reservedBy;

  ShoppingItemReserved({required this.id, required this.reservedBy});

  @override
  List<Object> get props => [id, reservedBy];
}

class ShoppingItemBought extends ShoppingEvent {
  final String id;
  final String buyerId;

  const ShoppingItemBought({required this.id, required this.buyerId});

  @override
  List<Object> get props => [id, buyerId];
}

class ShoppingItemReservationCancelled extends ShoppingEvent {
  final String id;

  const ShoppingItemReservationCancelled({required this.id});

  @override
  List<Object> get props => [id];
}
