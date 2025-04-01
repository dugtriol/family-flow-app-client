import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_repository/shopping_repository.dart';
import '../bloc/shopping_bloc.dart';
import 'create_shopping_button.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingRepository =
        RepositoryProvider.of<ShoppingRepository>(context);
    return BlocProvider(
      create: (context) => ShoppingBloc(shoppingRepository: shoppingRepository)
        ..add(ShoppingListRequested()),
      child: const ShoppingView(),
    );
  }
}

class ShoppingView extends StatelessWidget {
  const ShoppingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ShoppingBloc>().add(ShoppingListRequested());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                context.select((ShoppingBloc bloc) =>
                    bloc.state is ShoppingLoadSuccess &&
                    (bloc.state as ShoppingLoadSuccess).isPublic),
                context.select((ShoppingBloc bloc) =>
                    bloc.state is ShoppingLoadSuccess &&
                    !(bloc.state as ShoppingLoadSuccess).isPublic),
              ],
              onPressed: (index) {
                final isPublic = index == 0;
                context.read<ShoppingBloc>().add(ShoppingTypeChanged(isPublic));
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Public'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Private'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                if (state is ShoppingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShoppingLoadSuccess) {
                  if (state.items.isEmpty) {
                    return const Center(
                        child: Text('No shopping items found.'));
                  }
                  return ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text('Visibility: ${item.visibility}'),
                      );
                    },
                  );
                } else if (state is ShoppingLoadFailure) {
                  return const Center(
                      child: Text('Failed to load shopping items.'));
                }
                return const Center(
                    child: Text('Press refresh to load shopping items.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const CreateShoppingButton(),
    );
  }
}
