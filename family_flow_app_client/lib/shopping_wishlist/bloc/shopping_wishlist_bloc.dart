import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

import '../../shopping/bloc/shopping_bloc.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';

part 'shopping_wishlist_event.dart';
part 'shopping_wishlist_state.dart';

class ShoppingWishlistBloc
    extends Bloc<ShoppingWishlistEvent, ShoppingWishlistState> {
  ShoppingWishlistBloc({
    required ShoppingRepository shoppingRepository,
    required WishlistRepository wishlistRepository,
  })  : _shoppingBloc = ShoppingBloc(shoppingRepository: shoppingRepository),
        _wishlistBloc = WishlistBloc(wishlistRepository: wishlistRepository),
        super(const ShoppingWishlistState.shopping()) {
    on<ShoppingTabSelected>(_onShoppingTabSelected);
    on<WishlistTabSelected>(_onWishlistTabSelected);
  }

  final ShoppingBloc _shoppingBloc;
  final WishlistBloc _wishlistBloc;

  void _onShoppingTabSelected(
      ShoppingTabSelected event, Emitter<ShoppingWishlistState> emit) {
    emit(const ShoppingWishlistState.shopping());
  }

  void _onWishlistTabSelected(
      WishlistTabSelected event, Emitter<ShoppingWishlistState> emit) {
    emit(const ShoppingWishlistState.wishlist());
  }

  ShoppingBloc get shoppingBloc => _shoppingBloc;
  WishlistBloc get wishlistBloc => _wishlistBloc;
}
