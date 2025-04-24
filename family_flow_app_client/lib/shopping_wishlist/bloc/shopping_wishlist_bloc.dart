import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:family_repository/family_repository.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

import '../../shopping/bloc/shopping_bloc.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../family/bloc/family_bloc.dart'; // Импорт FamilyBloc

part 'shopping_wishlist_event.dart';
part 'shopping_wishlist_state.dart';

class ShoppingWishlistBloc
    extends Bloc<ShoppingWishlistEvent, ShoppingWishlistState> {
  ShoppingWishlistBloc({
    required ShoppingRepository shoppingRepository,
    required WishlistRepository wishlistRepository,
    required FamilyBloc familyBloc, // Добавляем FamilyBloc
  }) : _shoppingBloc = ShoppingBloc(
         shoppingRepository: shoppingRepository,
         familyBloc: familyBloc,
       ),
       _wishlistBloc = WishlistBloc(
         wishlistRepository: wishlistRepository,
         familyBloc: familyBloc,
       ),
       _familyBloc = familyBloc, // Инициализируем FamilyBloc

       super(const ShoppingWishlistState.shopping()) {
    on<ShoppingTabSelected>(_onShoppingTabSelected);
    on<WishlistTabSelected>(_onWishlistTabSelected);
  }

  final ShoppingBloc _shoppingBloc;
  final WishlistBloc _wishlistBloc;
  final FamilyBloc _familyBloc; // Хранение FamilyBloc

  void _onShoppingTabSelected(
    ShoppingTabSelected event,
    Emitter<ShoppingWishlistState> emit,
  ) {
    emit(const ShoppingWishlistState.shopping());
  }

  void _onWishlistTabSelected(
    WishlistTabSelected event,
    Emitter<ShoppingWishlistState> emit,
  ) {
    emit(const ShoppingWishlistState.wishlist());
  }

  ShoppingBloc get shoppingBloc => _shoppingBloc;
  WishlistBloc get wishlistBloc => _wishlistBloc;
  FamilyBloc get familyBloc => _familyBloc; // Геттер для FamilyBloc
}
