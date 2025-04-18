import 'package:family_flow_app_client/chats/chats.dart';
import 'package:family_flow_app_client/home/cubit/home_cubit.dart';
import 'package:family_flow_app_client/shopping/shopping.dart';
import 'package:family_repository/family_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_repository/shopping_repository.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:wishlist_repository/wishlist_repository.dart';

import '../../authentication/authentication.dart';
import '../../family/family.dart';
import '../../geolocation/geolocation.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../profile/view/view.dart';

import '../../shopping_wishlist/shopping_wishlist.dart';
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
    final shoppingRepository = RepositoryProvider.of<ShoppingRepository>(
      context,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => HomeCubit(
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
            create:
                (_) =>
                    TodoBloc(todoRepository: todoRepository)
                      ..add(TodoAssignedToRequested())
                      ..add(TodoCreatedByRequested()),
            child: const TodoPage(),
          ),
          const ChatsPage(),
          BlocProvider(
            create: (_) => GeolocationBloc(),
            child: const GeolocationPage(),
          ),
          BlocProvider(
            create:
                (context) => ShoppingWishlistBloc(
                  shoppingRepository: context.read<ShoppingRepository>(),
                  wishlistRepository: context.read<WishlistRepository>(),
                ),
            child: const ShoppingWishlistPage(),
          ),
          BlocProvider(
            create:
                (context) => ProfileBloc(
                  authenticationBloc: context.read<AuthenticationBloc>(),
                  familyRepository: context.read<FamilyRepository>(),
                )..add(ProfileRequested()),
            child: const ProfilePage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white, // Цвет нижнего бара
        elevation: 4, // Тень для разделения
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.main,
              icon: const Icon(Icons.check_circle_outline),
              label: 'Задачи',
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.messages,
              icon: const Icon(Icons.chat_rounded),
              label: 'Сообщения',
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.geolocation,
              icon: const Icon(Icons.location_on_rounded),
              label: 'Геолокация',
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.shoppingwishlists,
              icon: const Icon(Icons.shopping_bag),
              label: 'Списки',
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.profile,
              icon: const Icon(Icons.person_rounded),
              label: 'Профиль',
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
    required this.label,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;

    return GestureDetector(
      onTap: () => context.read<HomeCubit>().setTab(value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              size: 22, // Размер иконки
              color:
                  isSelected
                      ? Colors
                          .deepPurple // Цвет активной вкладки
                      : Colors.grey, // Цвет неактивной вкладки
            ),
            child: icon,
          ),
          const SizedBox(height: 2), // Отступ между иконкой и текстом
          Text(
            label,
            style: TextStyle(
              fontSize: 10, // Размер текста
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color:
                  isSelected
                      ? Colors
                          .deepPurple // Цвет активной вкладки
                      : Colors.grey, // Цвет неактивной вкладки
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Экран "$title" в разработке',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
