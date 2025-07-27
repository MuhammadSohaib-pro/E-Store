import 'package:e_commerece_website_testing/models/product.dart';
import 'package:e_commerece_website_testing/services/product_service.dart';

class ProductsRepository {
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductService.getAllProducts();
  }
}
