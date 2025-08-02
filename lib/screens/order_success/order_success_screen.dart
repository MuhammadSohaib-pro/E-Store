import 'package:auto_route/auto_route.dart';
import 'package:e_store/routes/app_router.gr.dart';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderSuccessScreen extends StatefulWidget {
  final String? orderId;
  final double? amount;

  const OrderSuccessScreen({
    super.key,
    @QueryParam('order_id') this.orderId,
    @QueryParam('amount') this.amount,
  });

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _contentController;
  late AnimationController _floatingController;

  late Animation<double> _checkmarkAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();

    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkmarkController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkmarkController,
        curve: const Interval(0.0, 0.5, curve: Curves.bounceOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _checkmarkController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _contentController.forward();

    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _contentController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderId =
        widget.orderId ?? 'ORD${DateTime.now().millisecondsSinceEpoch}';
    final amount = widget.amount ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Order Confirmed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Floating background elements
          ...List.generate(6, (index) => _buildFloatingElement(index)),

          // Main content
          Responsive(
            mobile: _buildMobileLayout(orderId, amount),
            desktop: _buildDesktopLayout(orderId, amount),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingElement(int index) {
    final colors = [
      Colors.green.withValues(alpha: 0.1),
      Colors.blue.withValues(alpha: 0.1),
      Colors.orange.withValues(alpha: 0.1),
      Colors.purple.withValues(alpha: 0.1),
      Colors.pink.withValues(alpha: 0.1),
      Colors.teal.withValues(alpha: 0.1),
    ];

    final sizes = [60.0, 80.0, 40.0, 100.0, 50.0, 70.0];
    final positions = [
      const Offset(50, 100),
      const Offset(300, 150),
      const Offset(100, 300),
      const Offset(250, 400),
      const Offset(150, 500),
      const Offset(350, 250),
    ];

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Positioned(
          left: positions[index].dx,
          top:
              positions[index].dy +
              (_floatingAnimation.value * (index % 2 == 0 ? 1 : -1)),
          child: Container(
            width: sizes[index],
            height: sizes[index],
            decoration: BoxDecoration(
              color: colors[index],
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(String orderId, double amount) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildSuccessAnimation(),
          const SizedBox(height: 40),
          _buildSuccessContent(orderId, amount),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(String orderId, double amount) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSuccessAnimation(),
              const SizedBox(height: 40),
              _buildSuccessContent(orderId, amount),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessAnimation() {
    return AnimatedBuilder(
      animation: _checkmarkController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Checkmark
                Center(
                  child: CustomPaint(
                    size: const Size(50, 50),
                    painter: CheckmarkPainter(_checkmarkAnimation.value),
                  ),
                ),

                // Ripple effect
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _checkmarkAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: RipplePainter(_checkmarkAnimation.value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessContent(String orderId, double amount) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Success message
                Text(
                  'Order Confirmed!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                Text(
                  'Thank you for your purchase! Your order has been confirmed and will be shipped soon.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Order details card
                Container(
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
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.receipt_long,
                              color: Colors.green.shade600,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Order Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'CONFIRMED',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Order info rows
                      _buildOrderInfoRow('Order ID', orderId),
                      _buildOrderInfoRow(
                        'Amount',
                        '\$${amount.toStringAsFixed(2)}',
                      ),
                      _buildOrderInfoRow(
                        'Order Date',
                        _formatDate(DateTime.now()),
                      ),
                      _buildOrderInfoRow(
                        'Estimated Delivery',
                        _formatDate(
                          DateTime.now().add(const Duration(days: 5)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Next steps card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.blue.shade50, Colors.blue.shade100],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'What\'s Next?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildNextStepItem(
                        Icons.email_outlined,
                        'You\'ll receive an email confirmation shortly',
                      ),
                      _buildNextStepItem(
                        Icons.local_shipping_outlined,
                        'We\'ll notify you when your order ships',
                      ),
                      _buildNextStepItem(
                        Icons.track_changes_outlined,
                        'Track your package using the tracking number',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          AutoRouter.of(context).replaceAll([HomeRoute()]);
                        },
                        icon: const Icon(Icons.shopping_bag_outlined),
                        label: const Text(
                          'Continue Shopping',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Support section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.support_agent,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Need help?',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Contact our support team',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _showSupportDialog();
                        },
                        child: const Text('Contact'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showSupportDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.support_agent),
                SizedBox(width: 8),
                Text('Customer Support', style: TextStyle(color: Colors.black)),
              ],
            ),
            content: Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need help with your order?'),
                  SizedBox(height: 12),
                  Text('📧 Email: support@estore.com'),
                  Text('📞 Phone: +1 (555) 123-4567'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Open chat or contact form
                },
                child: const Text('Contact Us'),
              ),
            ],
          ),
    );
  }
}

// Custom painter for the checkmark animation
class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final path = Path();

    // Define checkmark points
    final p1 = Offset(size.width * 0.2, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.7);
    final p3 = Offset(size.width * 0.8, size.height * 0.3);

    if (progress > 0) {
      // First line (left part of checkmark)
      final firstLineProgress = (progress * 2).clamp(0.0, 1.0);
      final firstEnd = Offset.lerp(p1, p2, firstLineProgress)!;

      path.moveTo(p1.dx, p1.dy);
      path.lineTo(firstEnd.dx, firstEnd.dy);

      // Second line (right part of checkmark)
      if (progress > 0.5) {
        final secondLineProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
        final secondEnd = Offset.lerp(p2, p3, secondLineProgress)!;

        path.moveTo(p2.dx, p2.dy);
        path.lineTo(secondEnd.dx, secondEnd.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Custom painter for the ripple effect
class RipplePainter extends CustomPainter {
  final double progress;

  RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress > 0.7) {
      final rippleProgress = ((progress - 0.7) / 0.3).clamp(0.0, 1.0);
      final center = Offset(size.width / 2, size.height / 2);
      final radius = (size.width / 2) * rippleProgress;

      final paint =
          Paint()
            ..color = Colors.white.withValues(alpha: 0.3 * (1 - rippleProgress))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
