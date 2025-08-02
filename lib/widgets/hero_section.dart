import 'dart:async';
import 'package:e_store/utils/utils.dart';
import 'package:flutter/material.dart';

class HeroSection extends StatefulWidget {
  final List<String> heroImages;

  const HeroSection({super.key, required this.heroImages});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start timer to change image every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.heroImages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Responsive.isDesktop(context);
    final bool isTablet = Responsive.isTablet(context);

    final double containerHeight =
        isDesktop
            ? 600
            : isTablet
            ? 380
            : 260;

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: Container(
        key: ValueKey<int>(_currentIndex),
        height: containerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.heroImages[_currentIndex]),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(24),
          child: Text(
            'Welcome to Our Store',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
