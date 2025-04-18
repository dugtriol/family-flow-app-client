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
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const Icon(
                Icons.shopping_bag,
                color: Colors.deepPurple,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Списки',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.black54,
            tabs: [Tab(text: 'Покупки'), Tab(text: 'Желания')],
          ),
        ),
        backgroundColor: Colors.white, // Устанавливаем цвет фона как у AppBar
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
