import 'package:equatable/equatable.dart';

abstract class ProductSpecificationsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductSpecificationsLoadRequested extends ProductSpecificationsEvent {
  final String productId;

  ProductSpecificationsLoadRequested({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ProductReviewsLoadRequested extends ProductSpecificationsEvent {
  final String productId;
  
  ProductReviewsLoadRequested({required this.productId});
  
  @override
  List<Object?> get props => [productId];
}