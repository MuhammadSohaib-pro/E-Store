import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/cart/cart_bloc.dart';
import 'package:e_store/blocs/cart/cart_state.dart';
import 'package:e_store/models/models.dart';
import 'package:e_store/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailAppBar extends StatelessWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggled;
  final VoidCallback onShare;

  const ProductDetailAppBar({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggled,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: Responsive.isMobile(context) ? 0 : 100,
      automaticallyImplyLeading: false,
      floating: true,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      title: Text(
        product.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          onPressed: onFavoriteToggled,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(isFavorite),
              color: isFavorite ? Colors.red : null,
            ),
          ),
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
        ),
        IconButton(
          onPressed: onShare,
          icon: const Icon(Icons.share),
          tooltip: 'Share product',
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final itemCount = state is CartLoaded ? state.itemCount : 0;
            return Stack(
              children: [
                IconButton(
                  onPressed: () => AutoRouter.of(context).pushPath('/cart'),
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'View cart',
                ),
                if (itemCount > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
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
              ],
            );
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
