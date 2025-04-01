import 'package:family_flow_app_client/home/cubit/home_cubit.dart';
import 'package:family_flow_app_client/shopping/shopping.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:todo_repository/todo_repository.dart';

import '../../family/family.dart';
import '../../profile/view/view.dart';
import '../../todo/todo.dart';
import '../../todo/view/todo_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    final todoRepository = RepositoryProvider.of<TodoRepository>(context);
    final familyRepository = RepositoryProvider.of<FamilyRepository>(context);
    final shoppingRepository =
        RepositoryProvider.of<ShoppingRepository>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeCubit(
            todoRepository: todoRepository,
            familyRepository: familyRepository,
            shoppingRepository: shoppingRepository,
          ),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    final todoRepository = context.read<HomeCubit>().todoRepository;
    final shoppingRepository = context.read<HomeCubit>().shoppingRepository;

    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: [
          BlocProvider(
            create: (_) => TodoBloc(todoRepository: todoRepository)
              ..add(TodoAssignedToRequested()),
            child: const TodoPage(),
          ),
          const PlaceholderScreen(title: 'Сообщения'),
          const PlaceholderScreen(title: 'Геолокация'),
          BlocProvider(
            create: (_) => ShoppingBloc(shoppingRepository: shoppingRepository),
            child: const ShoppingPage(),
          ),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.main,
              icon: const Icon(Icons.list_rounded, size: 24),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.messages,
              icon: const Icon(Icons.chat_rounded, size: 24),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.geolocation,
              icon: const Icon(Icons.location_on_rounded, size: 24),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.shoppingwishlists,
              icon: const Icon(Icons.shopping_cart_rounded, size: 24),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.profile,
              icon: const Icon(Icons.person_rounded, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<HomeCubit>().setTab(value),
      iconSize: 32,
      color:
          groupValue != value ? null : Theme.of(context).colorScheme.secondary,
      icon: icon,
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Экран "$title" в разработке',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
