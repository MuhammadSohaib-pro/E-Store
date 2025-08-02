import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/cart/cart_bloc.dart';
import 'package:e_store/blocs/cart/cart_event.dart';
import 'package:e_store/blocs/cart/cart_state.dart';
import 'package:e_store/screens/cart/components/promo_code_widget.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCheckoutSection extends StatelessWidget {
  final CartLoaded state;

  const CartCheckoutSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(Responsive.isMobile(context) ? 16 : 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildOrderSummary(),
          const SizedBox(height: 24),
          _buildPromoCodeSection(context),
          const SizedBox(height: 24),
          _buildCheckoutButton(context),
          const SizedBox(height: 12),
          _buildSecurityBadge(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.receipt_long, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        _buildSummaryRow('Subtotal', '\$${state.subtotal.toStringAsFixed(2)}'),
        _buildSummaryRow(
          'Shipping',
          state.shipping == 0
              ? 'Free'
              : '\$${state.shipping.toStringAsFixed(2)}',
        ),
        _buildSummaryRow(
          'Tax',
          state.tax == 0 ? '\$0.00' : '\$${state.tax.toStringAsFixed(2)}',
        ),
        if (state.discount > 0) ...[
          _buildSummaryRow(
            'Discount',
            '-\$${state.discount.toStringAsFixed(2)}',
            color: Colors.green,
          ),
        ],
        const Divider(height: 32),
        _buildSummaryRow(
          'Total',
          '\$${state.total.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: color ?? (isTotal ? Colors.green.shade600 : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection(BuildContext context) {
    return PromoCodeWidget(
      appliedPromoCode: state.promoCode,
      onPromoCodeApplied: (code) {
        context.read<CartBloc>().add(CartPromoCodeApplied(promoCode: code));
      },
      onPromoCodeRemoved: () {
        context.read<CartBloc>().add(CartPromoCodeRemoved());
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => AutoRouter.of(context).pushPath("/checkout"),
        icon: const Icon(Icons.lock_outline),
        label: const Text(
          'Proceed to Checkout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityBadge() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.security, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            'Secure checkout with 256-bit SSL encryption',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
