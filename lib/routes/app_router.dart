import 'package:auto_route/auto_route.dart';
import 'package:e_commerece_website_testing/routes/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Page|Screen,Route")
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: HomeRoute.page, initial: true),
    AutoRoute(path: '/search', page: SearchRoute.page),
    AutoRoute(path: '/products', page: ProductRoute.page),
    AutoRoute(path: '/product-detail/:id', page: ProductDetailRoute.page),
    AutoRoute(path: '/cart', page: CartRoute.page),
    AutoRoute(path: '/checkout', page: CheckoutRoute.page),
    AutoRoute(path: '/order-success', page: OrderSuccessRoute.page),
  ];
}
