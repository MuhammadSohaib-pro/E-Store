import 'package:flutter/material.dart';

class PromoCodeWidget extends StatefulWidget {
  final String? appliedPromoCode;
  final Function(String) onPromoCodeApplied;
  final VoidCallback onPromoCodeRemoved;

  const PromoCodeWidget({
    super.key,
    this.appliedPromoCode,
    required this.onPromoCodeApplied,
    required this.onPromoCodeRemoved,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isExpanded = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.appliedPromoCode != null) {
      return _buildAppliedPromoCode();
    }

    return _buildPromoCodeInput();
  }

  Widget _buildAppliedPromoCode() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo code applied',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
                Text(
                  widget.appliedPromoCode!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: widget.onPromoCodeRemoved,
            child: Text(
              'Remove',
              style: TextStyle(color: Colors.green.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              children: [
                const Icon(Icons.local_offer_outlined, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Have a promo code?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      decoration: InputDecoration(
                        hintText: 'Enter promo code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyPromoCode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim();
    if (code.isNotEmpty) {
      widget.onPromoCodeApplied(code);
      _promoController.clear();
      setState(() => _isExpanded = false);
    }
  }
}