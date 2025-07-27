import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PromoBanner extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String buttonText;
  final String imageUrl;
  final List<Color> gradientColors;
  final String actionType;
  final Map<String, dynamic> actionData;

  const PromoBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imageUrl,
    required this.gradientColors,
    required this.actionType,
    required this.actionData,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        buttonText,
        imageUrl,
        gradientColors,
        actionType,
        actionData,
      ];
}