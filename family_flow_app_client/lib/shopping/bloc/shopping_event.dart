part of 'shopping_bloc.dart';

abstract class ShoppingEvent extends Equatable {
  const ShoppingEvent();

  @override
  List<Object> get props => [];
}

class ShoppingListRequested extends ShoppingEvent {}

class ShoppingItemCreateRequested extends ShoppingEvent {
  const ShoppingItemCreateRequested({
    required this.title,
    required this.description,
    required this.visibility,
  });

  final String title;
  final String description;
  final String visibility;

  @override
  List<Object> get props => [title, description, visibility];
}

class ShoppingTypeChanged extends ShoppingEvent {
  const ShoppingTypeChanged(this.isPublic);

  final bool isPublic; // true для public, false для private

  @override
  List<Object> get props => [isPublic];
}
