import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shopping/view/shopping_page.dart';
import '../../wishlist/view/wishlist_page.dart';
import '../bloc/shopping_wishlist_bloc.dart';

class ShoppingWishlistPage extends StatelessWidget {
  const ShoppingWishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final shoppingWishlistBloc = context.read<ShoppingWishlistBloc>();

    return DefaultTabController(
      length: 2, // Количество вкладок
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping & Wishlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Shopping'),
              Tab(text: 'Wishlist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocProvider.value(
              value: shoppingWishlistBloc.shoppingBloc,
              child: const ShoppingPage(),
            ),
            BlocProvider.value(
              value: shoppingWishlistBloc.wishlistBloc,
              child: const WishlistPage(),
            ),
          ],
        ),
      ),
    );
  }
}
