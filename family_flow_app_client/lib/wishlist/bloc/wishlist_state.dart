part of 'wishlist_bloc.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoadSuccess extends WishlistState {
  const WishlistLoadSuccess(this.items);

  final List<WishlistItem> items;

  @override
  List<Object> get props => [items];
}

class WishlistLoadFailure extends WishlistState {}

class WishlistNoFamily extends WishlistState {
  @override
  List<Object> get props => [];
}
