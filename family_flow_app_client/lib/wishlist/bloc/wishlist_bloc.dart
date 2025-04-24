import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart' show User;
import 'package:wishlist_api/wishlist_api.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

import '../../family/family.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({
    required WishlistRepository wishlistRepository,
    required FamilyBloc familyBloc,
  }) : _wishlistRepository = wishlistRepository,
       _familyBloc = familyBloc,
       super(WishlistInitial()) {
    on<WishlistRequested>(_onWishlistRequested);
    on<WishlistItemCreateRequested>(_onWishlistItemCreateRequested);
    on<WishlistItemUpdateRequested>(_onWishlistItemUpdateRequested);
  }

  final WishlistRepository _wishlistRepository;
  final FamilyBloc _familyBloc;

  List<User> get familyMembers {
    // Получаем список членов семьи из FamilyBloc
    final state = _familyBloc.state;
    if (state is FamilyLoadSuccess) {
      return state.members;
    }
    return [];
  }

  Future<void> _onWishlistRequested(
    WishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      print('_onWishlistRequested - Fetching wishlist items...');
      final items = await _wishlistRepository.fetchWishlistItems();
      print('_onWishlistRequested - Fetched ${items.length} wishlist items.');

      // Фильтруем список по memberId, если он указан
      final filteredItems =
          event.memberId != null
              ? items.where((item) => item.createdBy == event.memberId).toList()
              : items;

      if (event.memberId != null) {
        print(
          '_onWishlistRequested - Filtered items by memberId: ${event.memberId}, '
          'resulting in ${filteredItems.length} items.',
        );
      }

      emit(WishlistLoadSuccess(filteredItems));
      print('_onWishlistRequested - Wishlist loaded successfully.');
    } catch (error) {
      print(
        '_onWishlistRequested - Failed to fetch wishlist items. Error: $error',
      );
      emit(WishlistLoadFailure());
    }
  }

  Future<void> _onWishlistItemCreateRequested(
    WishlistItemCreateRequested event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      await _wishlistRepository.createWishlistItem(
        name: event.name,
        description: event.description,
        link: event.link,
      );
      add(WishlistRequested()); // Перезапрашиваем список после создания
    } catch (_) {
      emit(WishlistLoadFailure());
    }
  }

  Future<void> _onWishlistItemUpdateRequested(
    WishlistItemUpdateRequested event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      print('Updating wishlist item with ID: ${event.id}');
      await _wishlistRepository.updateWishlistItem(
        id: event.id,
        name: event.name,
        description: event.description,
        link: event.link,
        status: event.status,
        isReserved: event.isReserved,
      );
      print('Wishlist item with ID: ${event.id} updated successfully.');

      add(WishlistRequested()); // Перезапрашиваем список после обновления
    } catch (error) {
      print(
        'Failed to update wishlist item with ID: ${event.id}. Error: $error',
      );
      emit(WishlistLoadFailure());
    } finally {
      // Обновляем список после завершения операции
      add(WishlistRequested());
    }
  }
}
