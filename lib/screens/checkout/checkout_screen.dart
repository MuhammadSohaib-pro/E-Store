import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/cart/cart_bloc.dart';
import 'package:e_store/blocs/cart/cart_event.dart';
import 'package:e_store/blocs/cart/cart_state.dart';
import 'package:e_store/routes/app_router.gr.dart';
import 'package:e_store/services/services.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedCountry = 'US';
  bool _isProcessing = false;
  bool _saveAddress = false;
  String? _clientSecret;
  String? _customerId;
  int _currentStep = 0;

  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _countries = [
    'US',
    'CA',
    'GB',
    'AU',
    'DE',
    'FR',
    'IT',
    'ES',
    'NL',
    'BE',
  ];

  final List<String> _stepTitles = ['Shipping Information', 'Payment Details'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (kIsWeb) {
      StripeWebService.init();
    }

    _prefillTestData();
    _initializePayment();
    _animationController.forward();
  }

  void _prefillTestData() {
    _fullNameController.text = "Muhammad Sohaib";
    _emailController.text = "muhammadsohaib030@gmail.com";
    _addressLine1Controller.text = "Islamabad, Pakistan";
    _addressLine2Controller.text = "Rawalpindi, Pakistan";
    _cityController.text = "Rawalpindi";
    _stateController.text = "Punjab";
    _zipCodeController.text = "46300";
    _phoneController.text = "+92 300 1234567";
  }

  Future<void> _initializePayment() async {
    final state = context.read<CartBloc>().state;
    if (state is! CartLoaded || state.items.isEmpty) return;

    final totalAmount = state.total;

    setState(() => _isProcessing = true);

    try {
      final customer = await StripeWebService.createCustomer(
        email:
            _emailController.text.isNotEmpty
                ? _emailController.text
                : 'customer@example.com',
        name:
            _fullNameController.text.isNotEmpty
                ? _fullNameController.text
                : 'Customer Name',
      );

      if (customer != null) {
        _customerId = customer['id'];
        final paymentIntent = await StripeWebService.createPaymentIntent(
          amount: totalAmount,
          currency: 'usd',
          customerId: _customerId,
          metadata: {
            'order_id': DateTime.now().millisecondsSinceEpoch.toString(),
          },
        );

        if (paymentIntent != null) {
          setState(() => _clientSecret = paymentIntent['client_secret']);
        }
      }
    } catch (e) {
      debugPrint('Error initializing payment: $e');
      _showErrorDialog('Failed to initialize payment. Please try again.');
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoaded || state.items.isEmpty) {
            return _buildEmptyCart();
          }

          if (_isProcessing || _clientSecret == null) {
            return const Center(child: LoadingWidget());
          }

          return FadeTransition(
            opacity: _fadeAnimation,
            child: Responsive(
              mobile: _buildMobileLayout(state),
              desktop: _buildDesktopLayout(state),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Checkout',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: _buildStepIndicator(),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(_stepTitles.length, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            isCompleted || isActive
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                        border: Border.all(
                          color:
                              isActive
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        color:
                            isCompleted || isActive
                                ? Colors.white
                                : Colors.grey.shade600,
                        size: isCompleted ? 24 : 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _stepTitles[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                        color:
                            isActive
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (index < _stepTitles.length - 1)
                Container(
                  height: 2,
                  width: 20,
                  color:
                      index < _currentStep
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => AutoRouter.of(context).replaceAll([HomeRoute()]),
            child: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(CartLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            child: _buildCurrentStep(state),
          ),
          if (_currentStep < 2)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        child: const Text('Previous'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          _currentStep == 0 ? _validateAndContinue : null,
                      child: Text(_currentStep == 0 ? 'Continue' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(CartLoaded state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildCurrentStep(state),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(width: 400, child: _buildOrderSummary(state)),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(CartLoaded state) {
    switch (_currentStep) {
      case 0:
        return _buildShippingForm();
      case 1:
        return _buildPaymentSection(state);
      default:
        return _buildShippingForm();
    }
  }

  Widget _buildShippingForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Shipping Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Contact Information
          _buildSectionHeader('Contact Information'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _fullNameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator:
                      (value) =>
                          value?.isEmpty == true
                              ? 'Please enter your full name'
                              : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value!)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number (Optional)',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          const SizedBox(height: 32),

          // Shipping Address
          _buildSectionHeader('Shipping Address'),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressLine1Controller,
            label: 'Street Address',
            icon: Icons.home_outlined,
            validator:
                (value) =>
                    value?.isEmpty == true ? 'Please enter your address' : null,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressLine2Controller,
            label: 'Apartment, suite, etc. (Optional)',
            icon: Icons.apartment_outlined,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _cityController,
                  label: 'City',
                  icon: Icons.location_city_outlined,
                  validator:
                      (value) =>
                          value?.isEmpty == true
                              ? 'Please enter your city'
                              : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _stateController,
                  label: 'State/Province',
                  icon: Icons.map_outlined,
                  validator:
                      (value) =>
                          value?.isEmpty == true
                              ? 'Please enter your state'
                              : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _zipCodeController,
                  label: 'ZIP/Postal Code',
                  icon: Icons.local_post_office_outlined,
                  validator:
                      (value) =>
                          value?.isEmpty == true
                              ? 'Please enter your ZIP code'
                              : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    prefixIcon: const Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items:
                      _countries
                          .map(
                            (country) => DropdownMenuItem(
                              value: country,
                              child: Text(
                                country,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged:
                      (value) => setState(() => _selectedCountry = value!),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Save Address Option
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: CheckboxListTile(
              title: Text(
                'Save this address for future orders',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall!.copyWith(color: Colors.black),
              ),
              subtitle: const Text(
                'This will help you checkout faster next time',
              ),
              value: _saveAddress,
              onChanged:
                  (value) => setState(() => _saveAddress = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: Theme.of(context).primaryColor,
            ),
          ),

          if (Responsive.isDesktop(context)) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _validateAndContinue,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Continue to Payment'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSection(CartLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.payment_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Payment Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 32),

        if (_clientSecret != null)
          WebPaymentForm(
            clientSecret: _clientSecret!,
            amount: state.total,
            billingDetails: {
              'name':
                  _fullNameController.text.isEmpty
                      ? 'Customer'
                      : _fullNameController.text,
              'email':
                  _emailController.text.isEmpty
                      ? 'customer@example.com'
                      : _emailController.text,
              'address': {
                'line1':
                    _addressLine1Controller.text.isEmpty
                        ? '123 Main St'
                        : _addressLine1Controller.text,
                'line2': _addressLine2Controller.text,
                'city':
                    _cityController.text.isEmpty
                        ? 'City'
                        : _cityController.text,
                'state':
                    _stateController.text.isEmpty
                        ? 'State'
                        : _stateController.text,
                'postal_code':
                    _zipCodeController.text.isEmpty
                        ? '12345'
                        : _zipCodeController.text,
                'country': _selectedCountry,
              },
            },
            onSuccess: () {
              AutoRouter.of(context).navigatePath(
                '/order-success?order_id=${DateTime.now().millisecondsSinceEpoch}&amount=${state.total}',
              );
              context.read<CartBloc>().add(CartCleared());
            },
            onError: (error) => _showErrorDialog(error),
          ),

        if (Responsive.isDesktop(context)) ...[
          const SizedBox(height: 32),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep--),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Shipping'),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOrderSummary(CartLoaded state) {
    const double shipping = 0.0;
    const double tax = 0.0;
    final double subtotal = state.total;
    final double total = subtotal + shipping + tax;

    return Container(
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
          Row(
            children: [
              Icon(Icons.receipt_long, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              const Text(
                'Order Summary',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Order Items
          ...state.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item.product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Qty: ${item.quantity}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${item.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          const Divider(height: 32),

          _buildSummaryRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
          _buildSummaryRow(
            'Shipping',
            shipping == 0 ? 'Free' : '\$${shipping.toStringAsFixed(2)}',
          ),
          _buildSummaryRow(
            'Tax',
            tax == 0 ? '\$0.00' : '\$${tax.toStringAsFixed(2)}',
          ),

          const Divider(height: 24),

          _buildSummaryRow(
            'Total',
            '\$${total.toStringAsFixed(2)}',
            isTotal: true,
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.green.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your payment information is secure and encrypted',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green.shade600 : null,
            ),
          ),
        ],
      ),
    );
  }

  void _validateAndContinue() {
    if (_formKey.currentState?.validate() == true) {
      setState(() => _currentStep++);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                const Text(
                  'Payment Error',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
