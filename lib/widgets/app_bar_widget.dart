import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/cart/cart_bloc.dart';
import 'package:e_store/blocs/cart/cart_state.dart';
import 'package:e_store/routes/app_router.gr.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.storefront,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                AutoRouter.of(context).replaceAll([HomeRoute()]);
              },
              child: const Text(
                'E-Store',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          // Search bar for desktop
          if (Responsive.isDesktop(context))
            Container(
              width: 320,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16,
                  ),
                ),
                onTap: () => AutoRouter.of(context).pushPath('/search'),
                readOnly: true,
              ),
            ),

          // Mobile search icon
          if (!Responsive.isDesktop(context))
            IconButton(
              onPressed: () => AutoRouter.of(context).pushPath('/search'),
              icon: const Icon(Icons.search),
              tooltip: 'Search',
            ),

          const SizedBox(width: 8),

          // Cart icon with badge
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              int itemCount = 0;
              if (state is CartLoaded) {
                itemCount = state.itemCount;
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () => AutoRouter.of(context).pushPath('/cart'),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      tooltip: 'Shopping Cart',
                    ),
                    if (itemCount > 0)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: InkWell(
                          onTap: () => AutoRouter.of(context).pushPath('/cart'),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
