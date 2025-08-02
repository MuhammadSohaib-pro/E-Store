// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:e_store/screens/cart/cart_screen.dart' as _i1;
import 'package:e_store/screens/checkout/checkout_screen.dart' as _i2;
import 'package:e_store/screens/home/home_screen.dart' as _i3;
import 'package:e_store/screens/order_success/order_success_screen.dart' as _i4;
import 'package:e_store/screens/product_detail/product_detail_screen.dart'
    as _i5;
import 'package:e_store/screens/products/product_screen.dart' as _i6;
import 'package:e_store/screens/search/search_screen.dart' as _i7;
import 'package:flutter/material.dart' as _i9;

/// generated route for
/// [_i1.CartScreen]
class CartRoute extends _i8.PageRouteInfo<void> {
  const CartRoute({List<_i8.PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.CartScreen();
    },
  );
}

/// generated route for
/// [_i2.CheckoutScreen]
class CheckoutRoute extends _i8.PageRouteInfo<void> {
  const CheckoutRoute({List<_i8.PageRouteInfo>? children})
    : super(CheckoutRoute.name, initialChildren: children);

  static const String name = 'CheckoutRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.CheckoutScreen();
    },
  );
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeScreen();
    },
  );
}

/// generated route for
/// [_i4.OrderSuccessScreen]
class OrderSuccessRoute extends _i8.PageRouteInfo<OrderSuccessRouteArgs> {
  OrderSuccessRoute({
    _i9.Key? key,
    String? orderId,
    double? amount,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         OrderSuccessRoute.name,
         args: OrderSuccessRouteArgs(
           key: key,
           orderId: orderId,
           amount: amount,
         ),
         rawQueryParams: {'order_id': orderId, 'amount': amount},
         initialChildren: children,
       );

  static const String name = 'OrderSuccessRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final queryParams = data.queryParams;
      final args = data.argsAs<OrderSuccessRouteArgs>(
        orElse:
            () => OrderSuccessRouteArgs(
              orderId: queryParams.optString('order_id'),
              amount: queryParams.optDouble('amount'),
            ),
      );
      return _i4.OrderSuccessScreen(
        key: args.key,
        orderId: args.orderId,
        amount: args.amount,
      );
    },
  );
}

class OrderSuccessRouteArgs {
  const OrderSuccessRouteArgs({this.key, this.orderId, this.amount});

  final _i9.Key? key;

  final String? orderId;

  final double? amount;

  @override
  String toString() {
    return 'OrderSuccessRouteArgs{key: $key, orderId: $orderId, amount: $amount}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OrderSuccessRouteArgs) return false;
    return key == other.key &&
        orderId == other.orderId &&
        amount == other.amount;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode ^ amount.hashCode;
}

/// generated route for
/// [_i5.ProductDetailScreen]
class ProductDetailRoute extends _i8.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i9.Key? key,
    required String productId,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, productId: productId),
         rawPathParams: {'id': productId},
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ProductDetailRouteArgs>(
        orElse:
            () => ProductDetailRouteArgs(productId: pathParams.getString('id')),
      );
      return _i5.ProductDetailScreen(key: args.key, productId: args.productId);
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, required this.productId});

  final _i9.Key? key;

  final String productId;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, productId: $productId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key && productId == other.productId;
  }

  @override
  int get hashCode => key.hashCode ^ productId.hashCode;
}

/// generated route for
/// [_i6.ProductScreen]
class ProductRoute extends _i8.PageRouteInfo<void> {
  const ProductRoute({List<_i8.PageRouteInfo>? children})
    : super(ProductRoute.name, initialChildren: children);

  static const String name = 'ProductRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProductScreen();
    },
  );
}

/// generated route for
/// [_i7.SearchScreen]
class SearchRoute extends _i8.PageRouteInfo<void> {
  const SearchRoute({List<_i8.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SearchScreen();
    },
  );
}
