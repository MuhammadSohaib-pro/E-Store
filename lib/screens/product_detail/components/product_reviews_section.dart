import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_state.dart';
import 'package:e_commerece_website_testing/repositories/product_detail_repository.dart';
import 'package:e_commerece_website_testing/screens/product_detail/components/all_reviews_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSpecificationsBloc, ProductSpecificationsState>(
      builder: (context, state) {
        if (state is ProductSpecificationsLoaded) {
          return _buildReviews(context, state);
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReviews(BuildContext context, ProductSpecificationsLoaded state) {
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
              Icon(
                Icons.reviews_outlined,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                'Customer Reviews',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildReviewSummary(),
          const SizedBox(height: 24),
          if (state.reviewsLoading)
            const Center(child: CircularProgressIndicator())
          else if (state.reviews.isNotEmpty) ...[
            ...state.reviews.take(2).map((review) => _buildReviewItem(review)),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => _showAllReviews(context, state.reviews),
                child: const Text('View All Reviews'),
              ),
            ),
          ] else
            const Center(
              child: Text('No reviews yet'),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewSummary() {
    return Row(
      children: [
        const Text(
          '4.5',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 4),
              const Text('Based on 127 reviews'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewItem(ReviewModel review) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue,
                child: Text(
                  review.customerName[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review.rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 14,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(review.date),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(color: Colors.grey.shade700, height: 1.4),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }

  void _showAllReviews(BuildContext context, List<ReviewModel> reviews) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AllReviewsSheet(reviews: reviews),
    );
  }
}