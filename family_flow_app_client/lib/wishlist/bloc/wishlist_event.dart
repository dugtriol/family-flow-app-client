part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class WishlistRequested extends WishlistEvent {
  const WishlistRequested({this.memberId});

  final String? memberId; // Идентификатор члена семьи (может быть null)

  @override
  List<Object?> get props => [memberId];
}

class WishlistItemCreateRequested extends WishlistEvent {
  const WishlistItemCreateRequested({
    required this.name,
    required this.description,
    required this.link,
  });

  final String name;
  final String description;
  final String link;

  @override
  List<Object> get props => [name, description, link];
}

class WishlistItemUpdateRequested extends WishlistEvent {
  const WishlistItemUpdateRequested({
    required this.id,
    required this.name,
    required this.description,
    required this.link,
    required this.status,
    required this.isArchived,
  });

  final String id;
  final String name;
  final String description;
  final String link;
  final String status;
  final bool isArchived;

  @override
  List<Object> get props => [id, name, description, link, status, isArchived];
}

class WishlistItemDeleted extends WishlistEvent {
  final String id;

  const WishlistItemDeleted({required this.id});

  @override
  List<Object> get props => [id];
}

class WishlistItemReserved extends WishlistEvent {
  final String id;
  final String reservedBy;

  const WishlistItemReserved({required this.id, required this.reservedBy});

  @override
  List<Object> get props => [id, reservedBy];
}

class WishlistItemReservationCancelled extends WishlistEvent {
  final String id;

  const WishlistItemReservationCancelled({required this.id});

  @override
  List<Object> get props => [id];
}
