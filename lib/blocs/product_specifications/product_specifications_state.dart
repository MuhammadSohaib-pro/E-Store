import 'package:e_commerece_website_testing/repositories/product_detail_repository.dart';
import 'package:equatable/equatable.dart';

abstract class ProductSpecificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductSpecificationsInitial extends ProductSpecificationsState {}

class ProductSpecificationsLoading extends ProductSpecificationsState {}

class ProductSpecificationsLoaded extends ProductSpecificationsState {
  final Map<String, String> specifications;
  final List<ReviewModel> reviews;
  final bool reviewsLoading;

  ProductSpecificationsLoaded({
    required this.specifications,
    this.reviews = const [],
    this.reviewsLoading = false,
  });

  ProductSpecificationsLoaded copyWith({
    Map<String, String>? specifications,
    List<ReviewModel>? reviews,
    bool? reviewsLoading,
  }) {
    return ProductSpecificationsLoaded(
      specifications: specifications ?? this.specifications,
      reviews: reviews ?? this.reviews,
      reviewsLoading: reviewsLoading ?? this.reviewsLoading,
    );
  }

  @override
  List<Object?> get props => [specifications, reviews, reviewsLoading];
}

class ProductSpecificationsError extends ProductSpecificationsState {
  final String message;

  ProductSpecificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}