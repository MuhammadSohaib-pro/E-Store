import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_event.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerece_website_testing/repositories/product_detail_repository.dart';

class ProductSpecificationsBloc
    extends Bloc<ProductSpecificationsEvent, ProductSpecificationsState> {
  final ProductDetailRepository _repository;

  ProductSpecificationsBloc({required ProductDetailRepository repository})
    : _repository = repository,
      super(ProductSpecificationsInitial()) {
    on<ProductSpecificationsLoadRequested>(_onSpecificationsLoadRequested);
    on<ProductReviewsLoadRequested>(_onReviewsLoadRequested);
  }

  Future<void> _onSpecificationsLoadRequested(
    ProductSpecificationsLoadRequested event,
    Emitter<ProductSpecificationsState> emit,
  ) async {
    emit(ProductSpecificationsLoading());

    try {
      final product = await _repository.getProductById(event.productId);
      final specifications = await _repository.getProductSpecifications(
        product,
      );

      final loadedState = ProductSpecificationsLoaded(
        specifications: specifications,
        reviewsLoading: true,
      );

      emit(loadedState);

      // Load reviews in background
      add(ProductReviewsLoadRequested(productId: product.id));
    } catch (e) {
      emit(
        ProductSpecificationsError(
          message: 'Failed to load specifications: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onReviewsLoadRequested(
    ProductReviewsLoadRequested event,
    Emitter<ProductSpecificationsState> emit,
  ) async {
    if (state is ProductSpecificationsLoaded) {
      final currentState = state as ProductSpecificationsLoaded;

      try {
        final reviews = await _repository.getProductReviews(event.productId);

        emit(currentState.copyWith(reviews: reviews, reviewsLoading: false));
      } catch (e) {
        emit(currentState.copyWith(reviewsLoading: false));
      }
    }
  }
}
