import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_api/shopping_api.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:user_repository/user_repository.dart' show User;

import '../../family/family.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc({
    required ShoppingRepository shoppingRepository,
    required FamilyBloc familyBloc,
  }) : _shoppingRepository = shoppingRepository,
       _familyBloc = familyBloc,
       super(ShoppingInitial()) {
    on<ShoppingListRequested>(_onListRequested);
    on<ShoppingItemCreateRequested>(_onItemCreateRequested);
    on<ShoppingTypeChanged>(_onTypeChanged); // Обработка переключения типа
    on<ShoppingItemStatusUpdated>(_onItemStatusUpdated);
    on<ShoppingItemDeleted>(_onItemDeleted);
    on<ShoppingItemReserved>(_onItemReserved);
    on<ShoppingItemBought>(_onItemBought);
    on<ShoppingItemReservationCancelled>(_onItemReservationCancelled);
  }

  final ShoppingRepository _shoppingRepository;
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

  Future<void> _onListRequested(
    ShoppingListRequested event,
    Emitter<ShoppingState> emit,
  ) async {
    emit(ShoppingLoading());
    try {
      print('Fetching public shopping items...');
      final items = await _shoppingRepository.fetchPublicShoppingItems();
      print('Successfully fetched ${items.length} items.');
      emit(ShoppingLoadSuccess(items, true)); // По умолчанию public
    } catch (error) {
      print('Failed to fetch shopping items: $error');
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemCreateRequested(
    ShoppingItemCreateRequested event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      emit(ShoppingLoading());
      await _shoppingRepository.createShoppingItem(
        title: event.title,
        description: event.description,
        visibility: event.visibility,
      );
      final items = await _shoppingRepository.fetchPublicShoppingItems();
      emit(ShoppingLoadSuccess(items, true)); // Обновляем public список
    } catch (_) {
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onTypeChanged(
    ShoppingTypeChanged event,
    Emitter<ShoppingState> emit,
  ) async {
    emit(ShoppingLoading());
    try {
      final items =
          event.isPublic
              ? await _shoppingRepository.fetchPublicShoppingItems()
              : await _shoppingRepository.fetchPrivateShoppingItems();
      emit(ShoppingLoadSuccess(items, event.isPublic));
    } catch (_) {
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemStatusUpdated(
    ShoppingItemStatusUpdated event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      emit(ShoppingLoading());
      await _shoppingRepository.updateShoppingItem(
        id: event.id,
        title: event.title,
        description: event.description,
        status: event.status,
        visibility: event.visibility,
        isArchived: event.isArchived,
      );
      final items = await _shoppingRepository.fetchPublicShoppingItems();
      emit(ShoppingLoadSuccess(items, true));
    } catch (error) {
      print('Failed to update shopping item: $error');
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemDeleted(
    ShoppingItemDeleted event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      print('Attempting to delete shopping item with id: ${event.id}');
      emit(ShoppingLoading());
      await _shoppingRepository.deleteShoppingItem(event.id);
      print('Successfully deleted shopping item with id: ${event.id}');
      final items = await _shoppingRepository.fetchPublicShoppingItems();
      print('Fetched ${items.length} items after deletion.');
      emit(ShoppingLoadSuccess(items, true)); // Обновляем список
    } catch (error) {
      print(
        'Failed to delete shopping item with id: ${event.id}, error: $error',
      );
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemReserved(
    ShoppingItemReserved event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      emit(ShoppingLoading());
      await _shoppingRepository.updateReservedBy(
        id: event.id,
        reservedBy: event.reservedBy,
      );

      final items = await _shoppingRepository.fetchPublicShoppingItems();
      emit(ShoppingLoadSuccess(items, true));
    } catch (error) {
      print('Failed to reserve shopping item: $error');
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemBought(
    ShoppingItemBought event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      emit(ShoppingLoading());
      await _shoppingRepository.updateBuyerId(
        id: event.id,
        buyerId: event.buyerId,
      );

      final items = await _shoppingRepository.fetchPublicShoppingItems();
      emit(ShoppingLoadSuccess(items, true));
    } catch (error) {
      print('Failed to update buyerId for shopping item: $error');
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemReservationCancelled(
    ShoppingItemReservationCancelled event,
    Emitter<ShoppingState> emit,
  ) async {
    try {
      emit(ShoppingLoading());
      await _shoppingRepository.cancelReservedBy(event.id);

      final items = await _shoppingRepository.fetchPublicShoppingItems();
      emit(ShoppingLoadSuccess(items, true));
    } catch (error) {
      print('Failed to cancel reservation for shopping item: $error');
      emit(ShoppingLoadFailure());
    }
  }
}
