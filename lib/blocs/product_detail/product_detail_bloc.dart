import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_store/repositories/product_detail_repository.dart';
import 'package:e_store/repositories/cart_repository.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductDetailRepository _productDetailRepository;
  final CartRepository _cartRepository;

  ProductDetailBloc({
    required ProductDetailRepository productDetailRepository,
    required CartRepository cartRepository,
  }) : _productDetailRepository = productDetailRepository,
       _cartRepository = cartRepository,
       super(ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onProductDetailLoadRequested);
    on<ProductQuantityChanged>(_onProductQuantityChanged);
    on<ProductImageChanged>(_onProductImageChanged);
    on<ProductFavoriteToggled>(_onProductFavoriteToggled);
    on<ProductDescriptionToggled>(_onProductDescriptionToggled);
    on<ProductAddedToCart>(_onProductAddedToCart);
    on<RelatedProductsLoadRequested>(_onRelatedProductsLoadRequested);
  }

  Future<void> _onProductDetailLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    try {
      final productImages = await _productDetailRepository.getProductImages(
        event.productId,
      );
      final product = await _productDetailRepository.getProductById(
        event.productId,
      );
      final isFavorite = _productDetailRepository.isFavorite(event.productId);

      final loadedState = ProductDetailLoaded(
        product: product,
        productImages: productImages,
        isFavorite: isFavorite,
        relatedProductsLoading: true,
      );

      emit(loadedState);

      // Load related products in background
      add(
        RelatedProductsLoadRequested(
          category: product.category,
          excludeProductId: product.id,
        ),
      );
    } catch (e) {
      emit(
        ProductDetailError(
          message: 'Failed to load product details: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onProductQuantityChanged(
    ProductQuantityChanged event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(currentState.copyWith(quantity: event.quantity));
    }
  }

  Future<void> _onProductImageChanged(
    ProductImageChanged event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(currentState.copyWith(selectedImageIndex: event.imageIndex));
    }
  }

  Future<void> _onProductFavoriteToggled(
    ProductFavoriteToggled event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;

      try {
        final isFavorite = await _productDetailRepository.toggleFavorite(
          currentState.product.id,
        );

        emit(ProductFavoriteUpdated(isFavorite: isFavorite));
        emit(currentState.copyWith(isFavorite: isFavorite));
      } catch (e) {
        emit(
          ProductDetailError(
            message: 'Failed to update favorite: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onProductDescriptionToggled(
    ProductDescriptionToggled event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;
      emit(
        currentState.copyWith(
          showFullDescription: !currentState.showFullDescription,
        ),
      );
    }
  }

  Future<void> _onProductAddedToCart(
    ProductAddedToCart event,
    Emitter<ProductDetailState> emit,
  ) async {
    try {
      await _cartRepository.addItem(event.product, event.quantity);

      final currentState = state;
      emit(
        ProductAddedToCartSuccess(
          product: event.product,
          quantity: event.quantity,
        ),
      );
      emit(currentState);
    } catch (e) {
      emit(
        ProductDetailError(message: 'Failed to add to cart: ${e.toString()}'),
      );
    }
  }

  Future<void> _onRelatedProductsLoadRequested(
    RelatedProductsLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    if (state is ProductDetailLoaded) {
      final currentState = state as ProductDetailLoaded;

      try {
        final relatedProducts = await _productDetailRepository
            .getRelatedProducts(event.category, event.excludeProductId);

        emit(
          currentState.copyWith(
            relatedProducts: relatedProducts,
            relatedProductsLoading: false,
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(relatedProductsLoading: false));
      }
    }
  }
}
