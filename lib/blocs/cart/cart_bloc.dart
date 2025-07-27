import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerece_website_testing/repositories/cart_repository.dart';
import 'package:e_commerece_website_testing/models/models.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc({required CartRepository cartRepository})
      : _cartRepository = cartRepository,
        super(CartInitial()) {
    on<CartLoadRequested>(_onCartLoadRequested);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityUpdated>(_onCartItemQuantityUpdated);
    on<CartCleared>(_onCartCleared);
    on<CartPromoCodeApplied>(_onCartPromoCodeApplied);
    on<CartPromoCodeRemoved>(_onCartPromoCodeRemoved);
  }

  Future<void> _onCartLoadRequested(
    CartLoadRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(items);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onCartItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    try {
      emit(CartItemAdding());
      
      await _cartRepository.addItem(event.product, event.quantity);
      
      // Emit success state first
      emit(CartItemAddedSuccess(
        product: event.product,
        quantity: event.quantity,
      ));
      
      // Then load updated cart
      final items = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(items);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to add item: ${e.toString()}'));
    }
  }

  Future<void> _onCartItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Find product name before removing
      final items = await _cartRepository.getCartItems();
      final item = items.firstWhere(
        (item) => item.product.id == event.productId,
        orElse: () => throw Exception('Product not found in cart'),
      );
      
      await _cartRepository.removeItem(event.productId);
      
      // Emit success state first
      emit(CartItemRemovedSuccess(
        productId: event.productId,
        productName: item.product.name,
      ) );
      
      // Then load updated cart
      final updatedItems = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(updatedItems);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to remove item: ${e.toString()}'));
    }
  }

  Future<void> _onCartItemQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateQuantity(event.productId, event.quantity);
      
      final items = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(items);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to update quantity: ${e.toString()}'));
    }
  }

  Future<void> _onCartCleared(
    CartCleared event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.clearCart();
      
      final items = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(items);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to clear cart: ${e.toString()}'));
    }
  }

  Future<void> _onCartPromoCodeApplied(
    CartPromoCodeApplied event,
    Emitter<CartState> emit,
  ) async {
    try {
      final isValid = await _cartRepository.validatePromoCode(event.promoCode);
      
      if (isValid) {
        final items = await _cartRepository.getCartItems();
        final subtotal = _cartRepository.calculateSubtotal();
        final discount = _cartRepository.calculateDiscount(subtotal);
        
        emit(CartPromoApplied(
          promoCode: event.promoCode,
          discountAmount: discount,
        ));
        
        final cartState = _calculateCartTotals(items);
        emit(cartState);
      } else {
        emit(CartPromoError(message: 'Invalid promo code'));
        
        // Return to current cart state
        final items = await _cartRepository.getCartItems();
        final cartState = _calculateCartTotals(items);
        emit(cartState);
      }
    } catch (e) {
      emit(CartError(message: 'Failed to apply promo code: ${e.toString()}'));
    }
  }

  Future<void> _onCartPromoCodeRemoved(
    CartPromoCodeRemoved event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.removePromoCode();
      
      final items = await _cartRepository.getCartItems();
      final cartState = _calculateCartTotals(items);
      emit(cartState);
    } catch (e) {
      emit(CartError(message: 'Failed to remove promo code: ${e.toString()}'));
    }
  }

  CartLoaded _calculateCartTotals(List<CartItem> items) {
    const double shipping = 0.0;
    const double tax = 0.0;
    
    final subtotal = _cartRepository.calculateSubtotal();
    final discount = _cartRepository.calculateDiscount(subtotal);
    final total = _cartRepository.calculateTotal(subtotal, shipping, tax, discount);
    final itemCount = _cartRepository.itemCount;
    
    return CartLoaded(
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      discount: discount,
      total: total,
      promoCode: _cartRepository.appliedPromoCode,
      itemCount: itemCount,
    );
  }
}