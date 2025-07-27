import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(children: [_buildSearchField(context)]),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade600, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: const InputDecoration(
                hintText: 'Search for products...',
                border: InputBorder.none,
                fillColor: Colors.white,
                focusColor: Colors.white,
                hoverColor: Colors.white,
                filled: true,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              onPressed: onClear,
              icon: Icon(Icons.close, color: Colors.grey.shade600, size: 20),
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
        ],
      ),
    );
  }
}
