import 'package:flutter/material.dart';

class SearchResultsHeader extends StatelessWidget {
  final String query;
  final int resultCount;
  final String sortBy;
  final Function(String) onSortChanged;

  const SearchResultsHeader({
    super.key,
    required this.query,
    required this.resultCount,
    required this.sortBy,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Search Results',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$resultCount ${resultCount == 1 ? 'product' : 'products'} found for "$query"',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildSortDropdown(context),
        ],
      ),
    );
  }

  Widget _buildSortDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSortChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder:
          (context) => [
            _buildSortMenuItem('relevance', 'Relevance', Icons.auto_awesome),
            _buildSortMenuItem(
              'price_low',
              'Price: Low to High',
              Icons.arrow_upward,
            ),
            _buildSortMenuItem(
              'price_high',
              'Price: High to Low',
              Icons.arrow_downward,
            ),
            _buildSortMenuItem('rating', 'Highest Rated', Icons.star),
            _buildSortMenuItem('name', 'Name A-Z', Icons.sort_by_alpha),
          ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort, size: 18),
            const SizedBox(width: 4),
            Text(_getSortLabel(sortBy), style: TextStyle(color: Colors.black)),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSortMenuItem(
    String value,
    String title,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: Colors.black)),
          if (sortBy == value) ...[
            const Spacer(),
            Icon(Icons.check, size: 16, color: Colors.green.shade600),
          ],
        ],
      ),
    );
  }

  String _getSortLabel(String sortBy) {
    switch (sortBy) {
      case 'price_low':
        return 'Price ↑';
      case 'price_high':
        return 'Price ↓';
      case 'rating':
        return 'Rating';
      case 'name':
        return 'Name';
      default:
        return 'Relevance';
    }
  }
}
