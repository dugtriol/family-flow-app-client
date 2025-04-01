import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'shoppingwishlist_event.dart';
part 'shoppingwishlist_state.dart';

class ShoppingwishlistBloc extends Bloc<ShoppingwishlistEvent, ShoppingwishlistState> {
  ShoppingwishlistBloc() : super(ShoppingwishlistInitial()) {
    on<ShoppingwishlistEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
