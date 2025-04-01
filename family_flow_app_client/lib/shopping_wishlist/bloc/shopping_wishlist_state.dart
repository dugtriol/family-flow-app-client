part of 'shopping_wishlist_bloc.dart';

class ShoppingWishlistState extends Equatable {
  const ShoppingWishlistState._({required this.isShopping});

  const ShoppingWishlistState.shopping() : this._(isShopping: true);

  const ShoppingWishlistState.wishlist() : this._(isShopping: false);

  final bool isShopping;

  @override
  List<Object> get props => [isShopping];
}
