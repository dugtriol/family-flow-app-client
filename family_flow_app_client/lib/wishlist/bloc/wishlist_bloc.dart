import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wishlist_api/wishlist_api.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc({required WishlistRepository wishlistRepository})
      : _wishlistRepository = wishlistRepository,
        super(WishlistInitial()) {
    on<WishlistRequested>(_onWishlistRequested);
    on<WishlistItemCreateRequested>(_onWishlistItemCreateRequested);
    on<WishlistItemUpdateRequested>(_onWishlistItemUpdateRequested);
  }

  final WishlistRepository _wishlistRepository;

  Future<void> _onWishlistRequested(
      WishlistRequested event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepository.fetchWishlistItems();
      emit(WishlistLoadSuccess(items));
    } catch (_) {
      emit(WishlistLoadFailure());
    }
  }

  Future<void> _onWishlistItemCreateRequested(
      WishlistItemCreateRequested event, Emitter<WishlistState> emit) async {
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
      WishlistItemUpdateRequested event, Emitter<WishlistState> emit) async {
    try {
      await _wishlistRepository.updateWishlistItem(
        id: event.id,
        name: event.name,
        description: event.description,
        link: event.link,
        status: event.status,
        isReserved: event.isReserved,
      );
      add(WishlistRequested()); // Перезапрашиваем список после обновления
    } catch (_) {
      emit(WishlistLoadFailure());
    }
  }
}
