import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Categories',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => onCategorySelected(category),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Theme.of(
                      context,
                    ).primaryColor.withValues(alpha: 0.2),
                    checkmarkColor: Theme.of(context).primaryColor,
                    labelStyle: TextStyle(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.transparent,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
