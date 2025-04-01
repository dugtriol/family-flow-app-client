import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/wishlist_bloc.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WishlistBloc>().add(WishlistRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoadSuccess) {
            if (state.items.isEmpty) {
              return const Center(child: Text('No wishlist items found.'));
            }
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // TODO: Add logic for editing wishlist item
                    },
                  ),
                );
              },
            );
          } else if (state is WishlistLoadFailure) {
            return const Center(child: Text('Failed to load wishlist items.'));
          }
          return const Center(child: Text('Press refresh to load wishlist.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add logic for creating a new wishlist item
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
