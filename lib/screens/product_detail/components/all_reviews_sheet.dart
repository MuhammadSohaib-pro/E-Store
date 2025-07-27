import 'package:e_commerece_website_testing/repositories/product_detail_repository.dart';
import 'package:flutter/material.dart';

class AllReviewsSheet extends StatefulWidget {
  final List<ReviewModel> reviews;

  const AllReviewsSheet({super.key, required this.reviews});

  @override
  State<AllReviewsSheet> createState() => _AllReviewsSheetState();
}

class _AllReviewsSheetState extends State<AllReviewsSheet> {
  String _sortBy = 'newest';
  int _filterRating = 0;

  @override
  Widget build(BuildContext context) {
    final filteredReviews = _getFilteredAndSortedReviews();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildFiltersAndSort(),
          Expanded(child: _buildReviewsList(filteredReviews)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text(
            'All Reviews (${widget.reviews.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersAndSort() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(child: _buildRatingFilter()),
          const SizedBox(width: 16),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildRatingFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('All', _filterRating == 0, () {
            setState(() => _filterRating = 0);
          }),
          const SizedBox(width: 8),
          ...List.generate(5, (index) {
            final rating = 5 - index;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                '$rating ⭐',
                _filterRating == rating,
                () => setState(() => _filterRating = rating),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              selected ? Theme.of(context).primaryColor : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          isDense: true,
          items: const [
            DropdownMenuItem(
              value: 'newest',
              child: Text('Newest', style: TextStyle(color: Colors.black)),
            ),
            DropdownMenuItem(
              value: 'oldest',
              child: Text('Oldest', style: TextStyle(color: Colors.black)),
            ),
            DropdownMenuItem(
              value: 'highest',
              child: Text(
                'Highest Rated',
                style: TextStyle(color: Colors.black),
              ),
            ),
            DropdownMenuItem(
              value: 'lowest',
              child: Text(
                'Lowest Rated',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          onChanged: (value) => setState(() => _sortBy = value!),
        ),
      ),
    );
  }

  Widget _buildReviewsList(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No reviews found',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(reviews[index], index);
      },
    );
  }

  Widget _buildReviewCard(ReviewModel review, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 100 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: _getAvatarColor(review.customerName),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < review.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 16,
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
                  const SizedBox(height: 12),
                  Text(
                    review.comment,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      height: 1.5,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<ReviewModel> _getFilteredAndSortedReviews() {
    List<ReviewModel> filtered = widget.reviews;

    // Apply rating filter
    if (_filterRating > 0) {
      filtered =
          filtered.where((review) => review.rating == _filterRating).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'highest':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'lowest':
        filtered.sort((a, b) => a.rating.compareTo(b.rating));
        break;
    }

    return filtered;
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[name.hashCode % colors.length];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}
