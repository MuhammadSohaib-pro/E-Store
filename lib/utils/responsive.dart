// ignore_for_file: no_leading_underscores_for_local_identifiers

// Import necessary package for building responsive layouts
import 'package:flutter/material.dart';

/// A utility widget that provides a responsive layout based on screen size.
/// Displays different widgets depending on whether the device is a mobile, tablet, or desktop.
class Responsive extends StatelessWidget {
  // Widget to display for mobile devices
  final Widget mobile;

  // Optional widget to display for tablet devices (falls back to mobile if null)
  final Widget? tablet;

  // Widget to display for desktop devices
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  /// Determines if the device is considered mobile (width < 768).
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  /// Determines if the device is considered a tablet (width between 768 and 1024).
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
      MediaQuery.of(context).size.width >= 768;

  /// Determines if the device is considered a desktop (width >= 1024).
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  /// Determines if the device is considered a mini-desktop (width between 1024 and 1440).
  static bool isMiniDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024 &&
      MediaQuery.of(context).size.width < 1440;

  @override
  Widget build(BuildContext context) {
    // Get the current screen size
    final Size _size = MediaQuery.of(context).size;

    // If width is 1024 or more, show the desktop layout
    if (_size.width >= 1024) {
      return desktop;
    }
    // If width is between 768 and 1024, show the tablet layout if defined
    else if (_size.width >= 768 && tablet != null) {
      return tablet!;
    }
    // If width is less than 768, show the mobile layout
    else {
      return mobile;
    }
  }
}
