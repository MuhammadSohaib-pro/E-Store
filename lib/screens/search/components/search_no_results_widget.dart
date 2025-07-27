import 'package:auto_route/auto_route.dart';
import 'package:e_commerece_website_testing/routes/app_router.gr.dart';
import 'package:flutter/material.dart';

class SearchNoResultsWidget extends StatelessWidget {
  final String query;
  final List<String> suggestedSearches;
  final Function(String) onSuggestionSelected;

  const SearchNoResultsWidget({
    super.key,
    required this.query,
    required this.suggestedSearches,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNoResultsIcon(),
            const SizedBox(height: 24),
            _buildNoResultsTitle(context),
            const SizedBox(height: 12),
            _buildNoResultsMessage(context),
            const SizedBox(height: 32),
            _buildSuggestionsSection(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.search_off, size: 80, color: Colors.orange.shade400),
    );
  }

  Widget _buildNoResultsTitle(BuildContext context) {
    return Text(
      'No products found',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget _buildNoResultsMessage(BuildContext context) {
    return Column(
      children: [
        Text(
          'We couldn\'t find any products matching',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '"$query"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsSection(BuildContext context) {
    if (suggestedSearches.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(
          'Try these suggestions instead:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children:
              suggestedSearches.take(6).map((suggestion) {
                return InkWell(
                  onTap: () => onSuggestionSelected(suggestion),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => AutoRouter.of(context).replaceAll([HomeRoute()]),
            icon: const Icon(Icons.home),
            label: const Text('Browse All Products'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _showSearchTips(context),
          icon: const Icon(Icons.help_outline),
          label: const Text('Search Tips'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _showSearchTips(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text('Search Tips'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTip(
                  'Use general terms like "headphones" instead of specific brands',
                ),
                _buildTip('Check your spelling'),
                _buildTip('Try using fewer keywords'),
                _buildTip('Browse categories to discover products'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(tip, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
