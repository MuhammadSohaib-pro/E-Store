import 'package:e_store/models/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> allProducts;
  final bool isRefreshing;

  ProductsLoaded({required this.allProducts, this.isRefreshing = false});

  ProductsLoaded copyWith({List<Product>? allProducts, bool? isRefreshing}) {
    return ProductsLoaded(
      allProducts: allProducts ?? this.allProducts,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [allProducts, isRefreshing];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}
