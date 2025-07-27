import 'package:flutter/material.dart';

class SearchFiltersSection extends StatefulWidget {
  final List<String> selectedFilters;
  final Function(List<String>) onFiltersChanged;

  const SearchFiltersSection({
    super.key,
    required this.selectedFilters,
    required this.onFiltersChanged,
  });

  @override
  State<SearchFiltersSection> createState() => _SearchFiltersSectionState();
}

class _SearchFiltersSectionState extends State<SearchFiltersSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Column(
        children: [
          _buildFilterHeader(),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: _buildFilterContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return InkWell(
      onTap: _toggleExpanded,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.filter_list, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Filters',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            if (widget.selectedFilters.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${widget.selectedFilters.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (widget.selectedFilters.isNotEmpty)
              TextButton(
                onPressed: _clearAllFilters,
                child: const Text('Clear All'),
              ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterContent() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildPriceRangeFilter(),
          const SizedBox(height: 16),
          _buildRatingFilter(),
        ],
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPriceRangeChip('Under \$50', 'under_50'),
            _buildPriceRangeChip('\$50 - \$100', '50_100'),
            _buildPriceRangeChip('\$100 - \$200', '100_200'),
            _buildPriceRangeChip('Over \$200', 'over_200'),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRangeChip(String label, String value) {
    final isSelected = widget.selectedFilters.contains(value);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => _toggleFilter(value, selected),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Rating',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildRatingChip('4+ Stars', 'rating_4'),
            _buildRatingChip('3+ Stars', 'rating_3'),
            _buildRatingChip('2+ Stars', 'rating_2'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingChip(String label, String value) {
    final isSelected = widget.selectedFilters.contains(value);
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 14, color: Colors.amber),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => _toggleFilter(value, selected),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      side: BorderSide(
        color: isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey.shade300,
      ),
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleFilter(String filter, bool selected) {
    final updatedFilters = List<String>.from(widget.selectedFilters);
    
    if (selected) {
      updatedFilters.add(filter);
    } else {
      updatedFilters.remove(filter);
    }
    
    widget.onFiltersChanged(updatedFilters);
  }

  void _clearAllFilters() {
    widget.onFiltersChanged([]);
  }
}