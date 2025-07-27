import 'package:e_commerece_website_testing/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<String> heroImages;
  final bool showBackToTop;
  final HomeStatistics statistics;
  final List<PromoBanner> promoBanners;
  final bool isRefreshing;

  HomeLoaded({
    required this.allProducts,
    required this.filteredProducts,
    required this.heroImages,
    this.showBackToTop = false,
    required this.statistics,
    required this.promoBanners,
    this.isRefreshing = false,
  });

  HomeLoaded copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    List<String>? heroImages,
    bool? showBackToTop,
    HomeStatistics? statistics,
    List<PromoBanner>? promoBanners,
    bool? isRefreshing,
  }) {
    return HomeLoaded(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      heroImages: heroImages ?? this.heroImages,
      showBackToTop: showBackToTop ?? this.showBackToTop,
      statistics: statistics ?? this.statistics,
      promoBanners: promoBanners ?? this.promoBanners,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    heroImages,
    showBackToTop,
    statistics,
    promoBanners,
    isRefreshing,
  ];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

class HomeNewsletterSubscribedState extends HomeState {
  final String email;

  HomeNewsletterSubscribedState({required this.email});

  @override
  List<Object?> get props => [email];
}

class HomeNewsletterError extends HomeState {
  final String message;

  HomeNewsletterError({required this.message});

  @override
  List<Object?> get props => [message];
}
