import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSpecificationsSection extends StatelessWidget {
  const ProductSpecificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSpecificationsBloc, ProductSpecificationsState>(
      builder: (context, state) {
        if (state is ProductSpecificationsLoading) {
          return _buildLoadingState();
        }

        if (state is ProductSpecificationsError) {
          return _buildErrorState(state.message);
        }

        if (state is ProductSpecificationsLoaded) {
          return _buildSpecifications(context, state.specifications);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400),
          const SizedBox(height: 8),
          Text(
            'Failed to load specifications',
            style: TextStyle(color: Colors.red.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(BuildContext context, Map<String, String> specs) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
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
          Row(
            children: [
              Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'Specifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...specs.entries.map(
            (entry) => _buildSpecRow(entry.key, entry.value),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
