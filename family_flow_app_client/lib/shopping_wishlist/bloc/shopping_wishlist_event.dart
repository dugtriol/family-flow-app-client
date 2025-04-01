part of 'shopping_wishlist_bloc.dart';

abstract class ShoppingWishlistEvent extends Equatable {
  const ShoppingWishlistEvent();

  @override
  List<Object> get props => [];
}

class ShoppingTabSelected extends ShoppingWishlistEvent {}

class WishlistTabSelected extends ShoppingWishlistEvent {}
