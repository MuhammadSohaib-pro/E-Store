import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final ShippingAddress shippingAddress;
  final String? paymentIntentId;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    this.paymentIntentId,
  });
}

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

class ShippingAddress {
  final String fullName;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.fullName,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.phone,
  });

  bool get isValid {
    return fullName.isNotEmpty &&
           addressLine1.isNotEmpty &&
           city.isNotEmpty &&
           state.isNotEmpty &&
           zipCode.isNotEmpty &&
           country.isNotEmpty;
  }
}