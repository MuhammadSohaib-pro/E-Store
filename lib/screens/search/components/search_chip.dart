import 'package:flutter/material.dart';

class SearchChip extends StatelessWidget {
  final String text;
  final bool isHistory;
  final VoidCallback onTap;

  const SearchChip({
    super.key,
    required this.text,
    required this.onTap,
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isHistory
              ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isHistory
                ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isHistory ? Icons.history : Icons.search,
              size: 16,
              color: isHistory
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: isHistory
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade700,
                fontWeight: isHistory ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}