import 'package:e_store/models/models.dart';

abstract class CartEvent {}

class CartLoadRequested extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Product product;
  final int quantity;

  CartItemAdded({required this.product, this.quantity = 1});
}

class CartItemRemoved extends CartEvent {
  final String productId;

  CartItemRemoved({required this.productId});
}

class CartItemQuantityUpdated extends CartEvent {
  final String productId;
  final int quantity;

  CartItemQuantityUpdated({required this.productId, required this.quantity});
}

class CartCleared extends CartEvent {}

class CartPromoCodeApplied extends CartEvent {
  final String promoCode;

  CartPromoCodeApplied({required this.promoCode});
}

class CartPromoCodeRemoved extends CartEvent {}
