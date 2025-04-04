import 'package:authentication_repository/authentication_repository.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../../home/view/view.dart';
import '../../login/view/view.dart';
import '../../splash/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider(create: (_) => UserRepository()),
        RepositoryProvider(create: (_) => TodoRepository()),
        RepositoryProvider(
          create: (context) => FamilyRepository(
            userRepository: context.read<UserRepository>(),
          ),
        ),
        RepositoryProvider(create: (_) => ShoppingRepository()),
        RepositoryProvider(create: (_) => WishlistRepository())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (context) => AuthenticationBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
              todoRepository: context.read<TodoRepository>(),
              shoppingRepository: context.read<ShoppingRepository>(),
            )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => FamilyBloc(
              familyRepository: context.read<FamilyRepository>(),
            )..add(FamilyRequested()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unknown:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
