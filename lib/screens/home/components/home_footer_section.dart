import 'package:flutter/material.dart';
import 'package:e_store/utils/utils.dart';

class HomeFooterSection extends StatelessWidget {
  const HomeFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          if (Responsive.isDesktop(context))
            _buildDesktopFooter(context)
          else
            _buildMobileFooter(context),
          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade700),
          const SizedBox(height: 16),
          Text(
            '© 2025 E-Store. All rights reserved.',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildFooterSection(context, 'About E-Store', [
            'About Us',
            'Careers',
            'Press',
            'Contact',
          ]),
        ),
        Expanded(
          child: _buildFooterSection(context, 'Customer Service', [
            'Help Center',
            'Returns',
            'Shipping Info',
            'Size Guide',
          ]),
        ),
        Expanded(
          child: _buildFooterSection(context, 'Follow Us', [
            'Facebook',
            'Twitter',
            'Instagram',
            'YouTube',
          ]),
        ),
      ],
    );
  }

  Widget _buildMobileFooter(BuildContext context) {
    return Column(
      children: [
        _buildExpandableFooterSection(context, 'About E-Store', [
          'About Us',
          'Careers',
          'Press',
          'Contact',
        ]),
        const SizedBox(height: 16),
        _buildExpandableFooterSection(context, 'Customer Service', [
          'Help Center',
          'Returns',
          'Shipping Info',
          'Size Guide',
        ]),
        const SizedBox(height: 16),
        _buildExpandableFooterSection(context, 'Follow Us', [
          'Facebook',
          'Twitter',
          'Instagram',
          'YouTube',
        ]),
      ],
    );
  }

  Widget _buildExpandableFooterSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        children:
            items.map((item) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Tooltip(
                  message: item,
                  child: Text(
                    item,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ),
                onTap: () {
                  // Add navigation logic
                },
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFooterSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {}, // Add navigation logic
              child: Text(
                item,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
