import 'package:equatable/equatable.dart';
import 'package:e_store/models/models.dart';

abstract class ProductDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailLoadRequested extends ProductDetailEvent {
  final String productId;

  ProductDetailLoadRequested({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ProductQuantityChanged extends ProductDetailEvent {
  final int quantity;

  ProductQuantityChanged({required this.quantity});

  @override
  List<Object?> get props => [quantity];
}

class ProductImageChanged extends ProductDetailEvent {
  final int imageIndex;

  ProductImageChanged({required this.imageIndex});

  @override
  List<Object?> get props => [imageIndex];
}

class ProductFavoriteToggled extends ProductDetailEvent {}

class ProductDescriptionToggled extends ProductDetailEvent {}

class ProductAddedToCart extends ProductDetailEvent {
  final Product product;
  final int quantity;

  ProductAddedToCart({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class RelatedProductsLoadRequested extends ProductDetailEvent {
  final String category;
  final String excludeProductId;

  RelatedProductsLoadRequested({
    required this.category,
    required this.excludeProductId,
  });

  @override
  List<Object?> get props => [category, excludeProductId];
}
