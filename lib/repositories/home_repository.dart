import 'package:flutter/material.dart';
import 'package:e_commerece_website_testing/models/models.dart';
import 'package:e_commerece_website_testing/services/services.dart';

class HomeRepository {
  final Set<String> _subscribedEmails = {};

  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductService.getAllProducts();
  }

  Future<List<String>> getHeroImages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductService.getHeroImages();
  }


  Future<HomeStatistics> getHomeStatistics() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return const HomeStatistics(
      totalProducts: '10K+',
      totalCustomers: '50K+',
      averageRating: '4.8★',
      supportAvailability: '24/7',
    );
  }

  Future<List<PromoBanner>> getPromoBanners() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      PromoBanner(
        id: 'free_shipping',
        title: '🎉 Free Shipping',
        subtitle: 'On orders over \$50',
        buttonText: 'Shop Now',
        imageUrl:
            'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
        gradientColors: [Colors.orange.shade400, Colors.orange.shade600],
        actionType: 'navigate',
        actionData: {'route': '/products', 'filter': 'featured'},
      ),
      PromoBanner(
        id: 'summer_sale',
        title: '☀️ Summer Sale',
        subtitle: 'Up to 50% off selected items',
        buttonText: 'Browse Deals',
        imageUrl:
            'https://images.unsplash.com/photo-1441985250492-8b26e7b4e58c',
        gradientColors: [Colors.blue.shade400, Colors.blue.shade600],
        actionType: 'navigate',
        actionData: {'route': '/search', 'query': 'sale'},
      ),
      PromoBanner(
        id: 'new_arrivals',
        title: '✨ New Arrivals',
        subtitle: 'Check out the latest products',
        buttonText: 'Explore',
        imageUrl:
            'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04',
        gradientColors: [Colors.purple.shade400, Colors.purple.shade600],
        actionType: 'navigate',
        actionData: {'route': '/products', 'filter': 'new'},
      ),
    ];
  }

  Future<bool> subscribeToNewsletter(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Validate email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw Exception('Please enter a valid email address');
    }

    if (_subscribedEmails.contains(email.toLowerCase())) {
      throw Exception('This email is already subscribed');
    }

    _subscribedEmails.add(email.toLowerCase());
    return true;
  }

  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = ProductService.getAllProducts();
    // Return products with high ratings as featured
    return allProducts.where((product) => product.rating >= 4.5).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final allProducts = ProductService.getAllProducts();

    if (query.isEmpty) {
      return allProducts;
    }

    return allProducts
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()) ||
              product.tags.any(
                (tag) => tag.toLowerCase().contains(query.toLowerCase()),
              ),
        )
        .toList();
  }

}
