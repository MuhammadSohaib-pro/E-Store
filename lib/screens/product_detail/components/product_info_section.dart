import 'package:e_commerece_website_testing/models/product.dart';
import 'package:e_commerece_website_testing/screens/product_detail/components/components.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final int quantity;
  final bool showFullDescription;
  final bool isDesktop;
  final Function(int) onQuantityChanged;
  final VoidCallback onDescriptionToggled;
  final VoidCallback? onAddToCart;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.quantity,
    required this.showFullDescription,
    required this.onQuantityChanged,
    required this.onDescriptionToggled,
    this.isDesktop = false,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryBadge(context),
          const SizedBox(height: 16),
          _buildProductName(context),
          const SizedBox(height: 12),
          _buildRatingAndReviews(),
          const SizedBox(height: 20),
          _buildPriceSection(),
          const SizedBox(height: 24),
          _buildDescriptionSection(context),
          if (product.tags.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildFeaturesSection(context),
          ],
          const SizedBox(height: 24),
          _buildQuantitySection(context),
          if (isDesktop && onAddToCart != null) ...[
            const SizedBox(height: 24),
            _buildAddToCartButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        product.category.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildProductName(BuildContext context) {
    return Text(
      product.name,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        height: 1.2,
      ),
    );
  }

  Widget _buildRatingAndReviews() {
    return Row(
      children: [
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < product.rating.floor()
                  ? Icons.star
                  : index < product.rating
                  ? Icons.star_half
                  : Icons.star_border,
              color: Colors.amber,
              size: 20,
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          '${product.rating} (127 reviews)',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        if (product.price > 100)
          Text(
            '\$${(product.price * 1.2).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState:
              showFullDescription
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
          firstChild: Text(
            product.description,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.6,
              fontSize: 16,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          secondChild: Text(
            '${product.description}\n\nThis product features premium materials and cutting-edge technology to deliver exceptional performance. Perfect for both everyday use and special occasions.',
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.6,
              fontSize: 16,
            ),
          ),
        ),
        if (product.description.length > 100)
          TextButton(
            onPressed: onDescriptionToggled,
            child: Text(showFullDescription ? 'Show less' : 'Read more'),
          ),
      ],
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              product.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySection(BuildContext context) {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const Spacer(),
        QuantitySelector(
          quantity: quantity,
          onQuantityChanged: onQuantityChanged,
        ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onAddToCart,
        icon: const Icon(Icons.add_shopping_cart),
        label: Text(
          'Add to Cart - \$${(product.price * quantity).toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
