import 'package:e_commerece_website_testing/models/product.dart';
import 'package:e_commerece_website_testing/utils/responsive.dart';
import 'package:e_commerece_website_testing/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;

  const SearchResultsGrid({
    super.key,
    required this.products,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && products.isEmpty) {
      return const Center(
        child: LoadingWidget(message: 'Searching products...'),
      );
    }

    if (products.isEmpty) {
      return _buildEmptyResults(context);
    }

    return Stack(
      children: [
        _buildProductGrid(context),
        if (isLoading) _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(Responsive.isDesktop(context) ? 20 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            Responsive.isMobile(context)
                ? 1
                : Responsive.isTablet(context)
                ? 2
                : 4,
        childAspectRatio:
            Responsive.isMobile(context)
                ? 0.85
                : Responsive.isTablet(context)
                ? 0.95
                : Responsive.isMiniDesktop(context)
                ? 0.85
                : 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductItem(products[index], index);
      },
    );
  }

  Widget _buildProductItem(Product product, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 200 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: ProductCard(product: product)),
        );
      },
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(height: 4, child: const LinearProgressIndicator()),
    );
  }

  Widget _buildEmptyResults(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No products found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Try adjusting your search or filters to find what you\'re looking for.',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
