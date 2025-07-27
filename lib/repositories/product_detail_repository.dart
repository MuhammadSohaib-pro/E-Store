import 'package:equatable/equatable.dart';
import 'package:e_commerece_website_testing/models/models.dart';
import 'package:e_commerece_website_testing/services/services.dart';

class ProductDetailRepository {
  final Set<String> _favoriteProductIds = {};

  Future<List<String>> getProductImages(String productId) async {
    return ProductService.getProductImagesById(productId);
  }
  Future<Product> getProductById(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ProductService.getProductById(productId);
  }

  Future<List<Product>> getRelatedProducts(
    String category,
    String excludeProductId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return ProductService.getAllProducts()
        .where((p) => p.category == category && p.id != excludeProductId)
        .take(4)
        .toList();
  }

  Future<bool> toggleFavorite(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
      return false;
    } else {
      _favoriteProductIds.add(productId);
      return true;
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  Future<void> shareProduct(Product product) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock sharing functionality
    // In real app, integrate with platform sharing
  }

  Future<Map<String, String>> getProductSpecifications(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      'Brand': 'Premium Brand',
      'Model': product.name,
      'Category': product.category,
      'Rating': '${product.rating}/5',
      'Availability': 'In Stock',
      'Shipping': 'Free shipping available',
      'Warranty': '1 Year Manufacturer Warranty',
      'Return Policy': '30 Days Easy Return',
    };
  }

  Future<List<ReviewModel>> getProductReviews(String productId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Mock reviews
    return [
      ReviewModel(
        id: '1',
        customerName: 'Sarah M.',
        rating: 5,
        comment: 'Excellent product! Exactly what I was looking for.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: '2',
        customerName: 'John D.',
        rating: 4,
        comment: 'Great quality and fast shipping. Highly recommended!',
        date: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ReviewModel(
        id: '3',
        customerName: 'Emily R.',
        rating: 5,
        comment: 'Amazing product, works perfectly and looks great!',
        date: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];
  }
}

// Review Model
class ReviewModel extends Equatable {
  final String id;
  final String customerName;
  final int rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [id, customerName, rating, comment, date];
}
