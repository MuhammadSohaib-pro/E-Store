import 'package:e_store/blocs/products/products_event.dart';
import 'package:e_store/blocs/products/products_state.dart';
import 'package:e_store/repositories/products_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository _productRepository;

  ProductsBloc({required ProductsRepository productRepository})
    : _productRepository = productRepository,
      super(ProductsInitial()) {
    on<ProductsInitialized>(_onHomeInitialized);
    on<ProductsRefreshRequested>(_onHomeRefreshRequested);
  }

  Future<void> _onHomeInitialized(
    ProductsInitialized event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    try {
      final allProducts = await _productRepository.getAllProducts();

      emit(ProductsLoaded(allProducts: allProducts));
    } catch (e) {
      emit(ProductsError(message: 'Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> _onHomeRefreshRequested(
    ProductsRefreshRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is! ProductsLoaded) return;

    final currentState = state as ProductsLoaded;
    emit(currentState.copyWith(isRefreshing: true));

    try {
      // Reload all data
      final allProducts = await _productRepository.getAllProducts();

      emit(ProductsLoaded(allProducts: allProducts, isRefreshing: false));
    } catch (e) {
      emit(currentState.copyWith(isRefreshing: false));
      emit(ProductsError(message: 'Failed to refresh data: ${e.toString()}'));
    }
  }
}
