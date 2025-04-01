part of 'wishlist_bloc.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class WishlistRequested extends WishlistEvent {}

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
    required this.isReserved,
  });

  final String id;
  final String name;
  final String description;
  final String link;
  final String status;
  final bool isReserved;

  @override
  List<Object> get props => [id, name, description, link, status, isReserved];
}
