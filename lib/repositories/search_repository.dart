import 'package:e_commerece_website_testing/models/models.dart';
import 'package:e_commerece_website_testing/services/services.dart';

class SearchRepository {
  final List<String> _searchHistory = [];
  final List<String> _suggestedSearches = [
    'wireless headphones',
    'smart watch',
    'laptop backpack',
    'smartphone',
    'coffee maker',
    'running shoes',
    'bluetooth speaker',
    'fitness tracker',
    'wireless charger',
    'gaming mouse',
  ];

  List<String> get searchHistory => List.unmodifiable(_searchHistory);
  List<String> get suggestedSearches => List.unmodifiable(_suggestedSearches);

  Future<List<Product>> searchProducts(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (query.isEmpty) {
      return ProductService.getAllProducts();
    }

    final allProducts = ProductService.getAllProducts();
    
    return allProducts.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase()) ||
        product.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  Future<List<Product>> filterProducts(
    List<Product> products,
    List<String> selectedFilters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (selectedFilters.isEmpty) {
      return products;
    }

    return products.where((product) =>
        selectedFilters.contains(product.category.toLowerCase())
    ).toList();
  }

  Future<List<Product>> sortProducts(
    List<Product> products,
    String sortBy,
  ) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final sortedProducts = List<Product>.from(products);

    switch (sortBy) {
      case 'price_low':
        sortedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        sortedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'name':
        sortedProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'relevance':
      default:
        // Keep original order for relevance
        break;
    }

    return sortedProducts;
  }

  Future<void> addToSearchHistory(String query) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (query.length > 2 && !_searchHistory.contains(query)) {
      _searchHistory.insert(0, query);
      if (_searchHistory.length > 10) {
        _searchHistory.removeLast();
      }
    }
  }

  Future<void> clearSearchHistory() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _searchHistory.clear();
  }

  Future<List<String>> getSearchSuggestions(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    if (query.isEmpty) {
      return _suggestedSearches.take(6).toList();
    }

    // Filter suggestions based on query
    final filteredSuggestions = _suggestedSearches
        .where((suggestion) => 
            suggestion.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    // Add some product-based suggestions
    final products = ProductService.getAllProducts();
    final productSuggestions = products
        .where((product) => 
            product.name.toLowerCase().contains(query.toLowerCase()))
        .map((product) => product.name.toLowerCase())
        .take(3)
        .toList();

    return [...filteredSuggestions, ...productSuggestions];
  }

  Future<List<String>> getTrendingSearches() async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    // Mock trending searches based on popularity
    return [
      'bluetooth headphones',
      'smart watch',
      'laptop',
      'coffee maker',
      'running shoes',
      'smartphone case',
    ];
  }
}