import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:family_repository/family_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required TodoRepository todoRepository,
    required FamilyRepository familyRepository,
    required ShoppingRepository shoppingRepository,
  })  : _todoRepository = todoRepository,
        _familyRepository = familyRepository,
        _shoppingRepository = shoppingRepository,
        super(const HomeState());

  final TodoRepository _todoRepository;
  final FamilyRepository _familyRepository;
  final ShoppingRepository _shoppingRepository;

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));

  TodoRepository get todoRepository => _todoRepository;

  FamilyRepository get familyRepository => _familyRepository;

  ShoppingRepository get shoppingRepository => _shoppingRepository;
}
