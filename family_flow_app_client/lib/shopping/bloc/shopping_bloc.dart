import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_api/shopping_api.dart';
import 'package:shopping_repository/shopping_repository.dart';

part 'shopping_event.dart';
part 'shopping_state.dart';

class ShoppingBloc extends Bloc<ShoppingEvent, ShoppingState> {
  ShoppingBloc({required ShoppingRepository shoppingRepository})
      : _shoppingRepository = shoppingRepository,
        super(ShoppingInitial()) {
    on<ShoppingListRequested>(_onListRequested);
    on<ShoppingItemCreateRequested>(_onItemCreateRequested);
    on<ShoppingTypeChanged>(_onTypeChanged); // Обработка переключения типа
  }

  final ShoppingRepository _shoppingRepository;

  Future<void> _onListRequested(
      ShoppingListRequested event, Emitter<ShoppingState> emit) async {
    emit(ShoppingLoading());
    try {
      final items = await _shoppingRepository.fetchPublicShoppingItems();

      emit(ShoppingLoadSuccess(items, true)); // По умолчанию public
    } catch (_) {
      emit(ShoppingLoadFailure());
    }
  }

  Future<void> _onItemCreateRequested(
      ShoppingItemCreateRequested event, Emitter<ShoppingState> emit) async {
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
      ShoppingTypeChanged event, Emitter<ShoppingState> emit) async {
    emit(ShoppingLoading());
    try {
      final items = event.isPublic
          ? await _shoppingRepository.fetchPublicShoppingItems()
          : await _shoppingRepository.fetchPrivateShoppingItems();
      emit(ShoppingLoadSuccess(items, event.isPublic));
    } catch (_) {
      emit(ShoppingLoadFailure());
    }
  }
}
