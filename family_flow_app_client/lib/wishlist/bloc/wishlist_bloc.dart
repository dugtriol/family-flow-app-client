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
    on<WishlistItemDeleted>(_onWishlistItemDeleted);
    on<WishlistItemReserved>(_onWishlistItemReserved);
    on<WishlistItemReservationCancelled>(_onWishlistItemReservationCancelled);
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

  String getUserName(String userId) {
    final members = familyMembers; // Получаем список членов семьи
    final user = members.firstWhere(
      (member) => member.id == userId,
      orElse: () => User.empty,
    );
    return user.name;
  }

  Future<void> _onWishlistRequested(
    WishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      print('_onWishlistRequested - Fetching wishlist items...');
      final items =
          event.memberId != null
              ? await _wishlistRepository.fetchWishlistItemsByFamilyUserID(
                event.memberId!,
              )
              : await _wishlistRepository.fetchWishlistItems();

      print('_onWishlistRequested - Fetched ${items.length} wishlist items.');
      emit(WishlistLoadSuccess(items));
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
        isArchived: event.isArchived,
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

  Future<void> _onWishlistItemDeleted(
    WishlistItemDeleted event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());
      await _wishlistRepository.deleteWishlistItem(event.id);

      // Перезапрашиваем список после удаления
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoadSuccess(items));
    } catch (error) {
      print('Failed to delete wishlist item: $error');
      emit(WishlistLoadFailure());
    }
  }

  Future<void> _onWishlistItemReserved(
    WishlistItemReserved event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());
      await _wishlistRepository.updateReservedBy(
        id: event.id,
        reservedBy: event.reservedBy,
      );

      // Перезапрашиваем список после резервирования
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoadSuccess(items));
    } catch (error) {
      print('Failed to reserve wishlist item: $error');
      emit(WishlistLoadFailure());
    }
  }

  Future<void> _onWishlistItemReservationCancelled(
    WishlistItemReservationCancelled event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      emit(WishlistLoading());
      await _wishlistRepository.cancelUpdateReservedBy(event.id);

      // Перезапрашиваем список после отмены резервирования
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoadSuccess(items));
    } catch (error) {
      print('Failed to cancel reservation for wishlist item: $error');
      emit(WishlistLoadFailure());
    }
  }
}
