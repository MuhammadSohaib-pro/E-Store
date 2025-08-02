import 'package:equatable/equatable.dart';
import 'package:e_store/models/models.dart';

abstract class ProductDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;
  final List<String> productImages;
  final int selectedImageIndex;
  final int quantity;
  final bool isFavorite;
  final bool showFullDescription;
  final List<Product> relatedProducts;
  final bool relatedProductsLoading;

  ProductDetailLoaded({
    required this.product,
    required this.productImages,
    this.selectedImageIndex = 0,
    this.quantity = 1,
    this.isFavorite = false,
    this.showFullDescription = false,
    this.relatedProducts = const [],
    this.relatedProductsLoading = false,
  });

  ProductDetailLoaded copyWith({
    Product? product,
    List<String>? productImages,
    int? selectedImageIndex,
    int? quantity,
    bool? isFavorite,
    bool? showFullDescription,
    List<Product>? relatedProducts,
    bool? relatedProductsLoading,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      productImages: productImages ?? this.productImages,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      showFullDescription: showFullDescription ?? this.showFullDescription,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      relatedProductsLoading:
          relatedProductsLoading ?? this.relatedProductsLoading,
    );
  }

  @override
  List<Object?> get props => [
    product,
    productImages,
    selectedImageIndex,
    quantity,
    isFavorite,
    showFullDescription,
    relatedProducts,
    relatedProductsLoading,
  ];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductAddedToCartSuccess extends ProductDetailState {
  final Product product;
  final int quantity;

  ProductAddedToCartSuccess({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class ProductFavoriteUpdated extends ProductDetailState {
  final bool isFavorite;

  ProductFavoriteUpdated({required this.isFavorite});

  @override
  List<Object?> get props => [isFavorite];
}
