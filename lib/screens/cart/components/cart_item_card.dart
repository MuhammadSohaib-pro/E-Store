import 'package:e_commerece_website_testing/models/cart_item.dart';
import 'package:flutter/material.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;
  final int index;
  final bool isDesktop;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.index,
    required this.onQuantityChanged,
    required this.onRemove,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildCardContent(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Row(
      children: [
        _buildProductImage(context),
        const SizedBox(width: 16),
        Expanded(child: _buildProductDetails(context)),
        if (isDesktop) ...[
          const SizedBox(width: 16),
          _buildQuantityControls(context),
          const SizedBox(width: 24),
          _buildDesktopPriceAndActions(context),
        ],
      ],
    );
  }

  Widget _buildProductImage(BuildContext context) {
    return Container(
      width: isDesktop ? 100 : 80,
      height: isDesktop ? 100 : 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(item.product.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.product.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item.product.category,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${item.product.price.toStringAsFixed(2)} each',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        if (!isDesktop) ...[
          const SizedBox(height: 12),
          _buildMobilePriceAndActions(context),
        ],
      ],
    );
  }

  Widget _buildMobilePriceAndActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityControls(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(
                Icons.delete_outline,
                size: 16,
              ),
              label: const Text('Remove'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade600,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopPriceAndActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${item.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete_outline),
          color: Colors.red.shade600,
          tooltip: 'Remove item',
        ),
      ],
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: item.quantity > 1 
                ? () => onQuantityChanged(item.quantity - 1) 
                : null,
            icon: const Icon(Icons.remove, size: 18),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            splashRadius: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            onPressed: () => onQuantityChanged(item.quantity + 1),
            icon: const Icon(Icons.add, size: 18),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}