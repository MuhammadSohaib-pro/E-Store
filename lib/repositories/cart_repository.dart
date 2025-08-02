import 'package:e_store/models/models.dart';

class CartRepository {
  final List<CartItem> _items = [];
  String? _appliedPromoCode;
  double _discountPercentage = 0.0;

  List<CartItem> get items => List.unmodifiable(_items);
  String? get appliedPromoCode => _appliedPromoCode;

  Future<List<CartItem>> getCartItems() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    return items;
  }

  Future<void> addItem(Product product, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
  }

  Future<void> removeItem(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.removeWhere((item) => item.product.id == productId);
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final existingIndex = _items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _items.removeAt(existingIndex);
      } else {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: quantity,
        );
      }
    }
  }

  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _items.clear();
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
  }

  Future<bool> validatePromoCode(String promoCode) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock promo code validation
    final validCodes = {'SAVE10': 0.10, 'SAVE20': 0.20, 'WELCOME15': 0.15};

    if (validCodes.containsKey(promoCode.toUpperCase())) {
      _appliedPromoCode = promoCode.toUpperCase();
      _discountPercentage = validCodes[promoCode.toUpperCase()]!;
      return true;
    }

    return false;
  }

  Future<void> removePromoCode() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _appliedPromoCode = null;
    _discountPercentage = 0.0;
  }

  double calculateSubtotal() {
    return _items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  double calculateDiscount(double subtotal) {
    return subtotal * _discountPercentage;
  }

  double calculateTotal(
    double subtotal,
    double shipping,
    double tax,
    double discount,
  ) {
    return subtotal + shipping + tax - discount;
  }

  int get itemCount => _items.fold(0, (total, item) => total + item.quantity);
}
