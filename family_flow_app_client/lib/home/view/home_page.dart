import 'package:family_flow_app_client/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile/view/view.dart';
import '../../task_overview/view/view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);
    return Scaffold(
      body: IndexedStack(
        index: selectedTab.index,
        children: [TaskOverviewPage(), ProfilePage()],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: const CircleBorder(),
      //   key: const Key('homeView_addTodo_floatingActionButton'),
      //   onPressed: () => () {},
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.main,
              icon: const Icon(Icons.list_rounded),
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: HomeTab.profile,
              icon: const Icon(Icons.person_rounded),
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

// class _UserId extends StatelessWidget {
//   const _UserId();

//   Future<String?> _getJwtToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String?>(
//       future: _getJwtToken(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return const Text('Error loading JWT token');
//         } else {
//           final jwtToken = snapshot.data ?? 'No JWT token found';
//           return Text('JWT Token: $jwtToken');
//         }
//       },
//     );
//   }
// }
