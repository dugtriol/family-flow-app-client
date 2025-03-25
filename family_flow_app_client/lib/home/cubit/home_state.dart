part of 'home_cubit.dart';

enum HomeTab { main, profile }

final class HomeState extends Equatable {
  const HomeState({
    this.tab = HomeTab.main,
  });

  final HomeTab tab;

  @override
  List<Object> get props => [tab];
}
