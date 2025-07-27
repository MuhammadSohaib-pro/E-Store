import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_bloc.dart';
import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_event.dart';
import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_state.dart';
import 'package:e_commerece_website_testing/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNewsletterSection extends StatefulWidget {
  const HomeNewsletterSection({super.key});

  @override
  State<HomeNewsletterSection> createState() => _HomeNewsletterSectionState();
}

class _HomeNewsletterSectionState extends State<HomeNewsletterSection>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewsletterBloc, NewsletterState>(
      listener: _handleNewsletterStateChanges,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Responsive(
          mobile: Column(
            children: [
              imageColumnSection(),
              newsLetterFormColumnSection(context),
            ],
          ),
          desktop: Row(
            children: [imageRowSection(), newsLetterFormRowSection(context)],
          ),
        ),
      ),
    );
  }

  Widget imageColumnSection() {
    return Column(
      children: [
        FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1590098563176-07884b06d7f7?w=800",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget imageRowSection() {
    return Expanded(
      child: Column(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://images.unsplash.com/photo-1590098563176-07884b06d7f7?w=800",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newsLetterFormColumnSection(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 480,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildEmailInput(),
              const SizedBox(height: 20),
              _buildBenefits(),
            ],
          ),
        ),
      ),
    );
  }

  Widget newsLetterFormRowSection(BuildContext context) {
    return Expanded(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            height: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildEmailInput(),
                const SizedBox(height: 20),
                _buildBenefits(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.email_outlined,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Stay Updated!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Subscribe to get special offers, free giveaways, and exclusive deals',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildEmailInput() {
    return SizedBox(
      width: Responsive.isDesktop(context) ? 400 : double.infinity,
      child: BlocBuilder<NewsletterBloc, NewsletterState>(
        builder: (context, state) {
          return TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Enter your email address',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              suffixIcon: _buildSubscribeButton(state),
            ),
            enabled: state is! NewsletterLoading,
          );
        },
      ),
    );
  }

  Widget _buildSubscribeButton(NewsletterState state) {
    if (state is NewsletterLoading) {
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: _subscribeToNewsletter,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12),
          elevation: 0,
        ),
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildBenefits() {
    return Column(
      children: [
        const Text(
          'What you\'ll get:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBenefit(Icons.local_offer, 'Exclusive\nOffers'),
            _buildBenefit(Icons.new_releases, 'Early\nAccess'),
            _buildBenefit(Icons.card_giftcard, 'Special\nDiscounts'),
          ],
        ),
      ],
    );
  }

  // In home_newsletter_section.dart, add this method:
  void _subscribeToNewsletter() {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address')),
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    context.read<NewsletterBloc>().add(
      NewsletterSubscriptionRequested(email: email),
    );
  }

  void _handleNewsletterStateChanges(
    BuildContext context,
    NewsletterState state,
  ) {
    if (state is NewsletterSuccess) {
      _emailController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.green),
      );
    } else if (state is NewsletterError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildBenefit(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
