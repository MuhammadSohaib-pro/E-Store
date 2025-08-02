import 'package:equatable/equatable.dart';
import 'package:e_store/models/models.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double discount;
  final double total;
  final String? promoCode;
  final int itemCount;

  CartLoaded({
    required this.items,
    required this.subtotal,
    this.shipping = 0.0,
    this.tax = 0.0,
    this.discount = 0.0,
    required this.total,
    this.promoCode,
    required this.itemCount,
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? shipping,
    double? tax,
    double? discount,
    double? total,
    String? promoCode,
    int? itemCount,
    bool clearPromoCode = false,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shipping: shipping ?? this.shipping,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      promoCode: clearPromoCode ? null : (promoCode ?? this.promoCode),
      itemCount: itemCount ?? this.itemCount,
    );
  }

  @override
  List<Object?> get props => [
    items,
    subtotal,
    shipping,
    tax,
    discount,
    total,
    promoCode,
    itemCount,
  ];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartItemAdding extends CartState {}

class CartItemAddedState extends CartState {
  final String productName;
  final int quantity;

  CartItemAddedState({required this.productName, required this.quantity});

  @override
  List<Object?> get props => [productName, quantity];
}

class CartItemRemovedState extends CartState {
  final String productName;

  CartItemRemovedState({required this.productName});

  @override
  List<Object?> get props => [productName];
}

class CartPromoApplied extends CartState {
  final String promoCode;
  final double discountAmount;

  CartPromoApplied({required this.promoCode, required this.discountAmount});

  @override
  List<Object?> get props => [promoCode, discountAmount];
}

class CartPromoError extends CartState {
  final String message;

  CartPromoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartItemAddedSuccess extends CartState {
  final Product product;
  final int quantity;

  CartItemAddedSuccess({required this.product, required this.quantity});
}

class CartItemRemovedSuccess extends CartState {
  final String productId;
  final String productName;

  CartItemRemovedSuccess({required this.productId, required this.productName});
}
