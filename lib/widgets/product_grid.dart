import 'package:e_commerece_website_testing/models/models.dart';
import 'package:e_commerece_website_testing/utils/utils.dart';
import 'package:e_commerece_website_testing/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final String? title;
  final bool showFilters;
  final bool isLoading;

  const ProductGrid({
    super.key,
    required this.products,
    this.title,
    this.showFilters = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Try adjusting your search criteria',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              Responsive.isMobile(context)
                  ? 1
                  : Responsive.isTablet(context)
                  ? 2
                  : Responsive.isMiniDesktop(context)
                  ? 3
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
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
