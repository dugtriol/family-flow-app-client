part of 'shopping_bloc.dart';

abstract class ShoppingState extends Equatable {
  const ShoppingState();

  @override
  List<Object> get props => [];
}

class ShoppingInitial extends ShoppingState {}

class ShoppingLoading extends ShoppingState {}

class ShoppingLoadSuccess extends ShoppingState {
  const ShoppingLoadSuccess(this.items, this.isPublic);

  final List<ShoppingItem> items;
  final bool isPublic;

  @override
  List<Object> get props => [items, isPublic];
}

class ShoppingLoadFailure extends ShoppingState {}

class ShoppingNoFamily extends ShoppingState {
  @override
  List<Object> get props => [];
}
