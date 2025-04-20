import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_repository/shopping_repository.dart';
import '../../authentication/authentication.dart';
import '../bloc/shopping_bloc.dart';
import 'create_shopping_button.dart';
import 'widgets/widgets.dart';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingRepository = RepositoryProvider.of<ShoppingRepository>(
      context,
    );
    return BlocProvider(
      create:
          (context) =>
              ShoppingBloc(shoppingRepository: shoppingRepository)
                ..add(ShoppingListRequested()),
      child: const ShoppingView(),
    );
  }
}

class ShoppingView extends StatelessWidget {
  const ShoppingView({super.key});

  Future<void> _refreshShoppingItems(BuildContext context) async {
    // Отправляем событие для обновления списка покупок
    context.read<ShoppingBloc>().add(ShoppingListRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => _refreshShoppingItems(context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ToggleButtons(
                isSelected: [
                  context.select(
                    (ShoppingBloc bloc) =>
                        bloc.state is ShoppingLoadSuccess &&
                        (bloc.state as ShoppingLoadSuccess).isPublic,
                  ),
                  context.select(
                    (ShoppingBloc bloc) =>
                        bloc.state is ShoppingLoadSuccess &&
                        !(bloc.state as ShoppingLoadSuccess).isPublic,
                  ),
                ],
                onPressed: (index) {
                  final isPublic = index == 0;
                  context.read<ShoppingBloc>().add(
                    ShoppingTypeChanged(isPublic),
                  );
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Доступны всем',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Личные',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
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
                        child: Text(
                          'Список покупок пуст.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        final currentUserId =
                            context.read<AuthenticationBloc>().state.user?.id;
                        final isOwner = item.createdBy == currentUserId;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Text(
                              item.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: TextButton.icon(
                              onPressed:
                                  item.status == 'Active'
                                      ? () {
                                        context.read<ShoppingBloc>().add(
                                          ShoppingItemStatusUpdated(
                                            id: item.id,
                                            title: item.title,
                                            description: item.description,
                                            status: 'Completed',
                                            visibility: item.visibility,
                                          ),
                                        );
                                      }
                                      : null,
                              icon: Icon(
                                item.status == 'Completed'
                                    ? Icons.check_circle
                                    : item.status == 'Reserved'
                                    ? Icons.lock
                                    : Icons.add_shopping_cart,
                                color:
                                    item.status == 'Completed'
                                        ? Colors.green
                                        : item.status == 'Reserved'
                                        ? Colors.orange
                                        : Colors.deepPurple,
                              ),
                              label: Text(
                                item.status == 'Completed'
                                    ? 'Куплено'
                                    : item.status == 'Reserved'
                                    ? 'Зарезервировано'
                                    : 'Куплю',
                                style: TextStyle(
                                  color:
                                      item.status == 'Completed'
                                          ? Colors.green
                                          : item.status == 'Reserved'
                                          ? Colors.orange
                                          : Colors.deepPurple,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider.value(
                                        value: context.read<ShoppingBloc>(),
                                        child: ShoppingDetailsPage(
                                          item: item,
                                          isOwner: isOwner,
                                          currentUser: currentUserId!,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is ShoppingLoadFailure) {
                    return const Center(
                      child: Text(
                        'Не удалось загрузить список покупок.',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'Потяните вниз, чтобы обновить список.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const CreateShoppingButton(),
    );
  }
}
