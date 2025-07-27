import 'package:e_commerece_website_testing/screens/search/components/components.dart';
import 'package:flutter/material.dart';

class SearchEmptyWidget extends StatelessWidget {
  final List<String> searchHistory;
  final List<String> suggestedSearches;
  final bool hasFocus;
  final Function(String) onHistoryItemSelected;
  final Function(String) onSuggestionSelected;
  final Function(String) onCategorySelected;
  final VoidCallback onHistoryCleared;

  const SearchEmptyWidget({
    super.key,
    required this.searchHistory,
    required this.suggestedSearches,
    required this.hasFocus,
    required this.onHistoryItemSelected,
    required this.onSuggestionSelected,
    required this.onCategorySelected,
    required this.onHistoryCleared,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchHistory.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              'Recent Searches',
              Icons.history,
              action: TextButton(
                onPressed: onHistoryCleared,
                child: Text(
                  'Clear',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildChipsList(searchHistory, onHistoryItemSelected, isHistory: true),
            const SizedBox(height: 32),
          ],
          _buildSectionHeader(context, 'Trending Searches', Icons.trending_up),
          const SizedBox(height: 16),
          _buildChipsList(suggestedSearches, onSuggestionSelected),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? action,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (action != null) ...[
          const Spacer(),
          action,
        ],
      ],
    );
  }

  Widget _buildChipsList(
    List<String> items,
    Function(String) onSelected, {
    bool isHistory = false,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.take(6).map((item) {
        return SearchChip(
          text: item,
          isHistory: isHistory,
          onTap: () => onSelected(item),
        );
      }).toList(),
    );
  }
}