import 'package:e_commerece_website_testing/models/models.dart';

class ProductService {
  static List<String> getHeroImages() {
    return [
      "https://images.unsplash.com/photo-1688561808434-886a6dd97b8c?w=800",
      "https://images.unsplash.com/photo-1651129518142-e0830a4c184b?w=800",
      "https://images.unsplash.com/photo-1585930437427-ac2efc8611a3?w=800",
      "https://images.unsplash.com/photo-1640161339472-a2d402b61a2f?w=800",
    ];
  }

  static List<Product> getAllProducts() {
    return [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'High-quality wireless headphones with noise cancellation',
        price: 199.99,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
        category: 'Electronics',
        rating: 4.5,
        tags: ['wireless', 'audio', 'headphones'],
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Feature-rich smartwatch with health monitoring',
        price: 299.99,
        imageUrl:
            'https://images.unsplash.com/photo-1617043786394-f977fa12eddf?w=800',
        category: 'Electronics',
        rating: 4.3,
        tags: ['smart', 'watch', 'fitness'],
      ),
      Product(
        id: '3',
        name: 'Laptop Backpack',
        description: 'Durable laptop backpack with multiple compartments',
        price: 79.99,
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
        category: 'Accessories',
        rating: 4.7,
        tags: ['backpack', 'laptop', 'travel'],
      ),
      Product(
        id: '4',
        name: 'Smartphone',
        description: 'Latest smartphone with advanced camera system',
        price: 899.99,
        imageUrl:
            'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
        category: 'Electronics',
        rating: 4.6,
        tags: ['phone', 'smartphone', 'mobile'],
      ),
      Product(
        id: '5',
        name: 'Coffee Maker',
        description: 'Automatic coffee maker with programmable settings',
        price: 149.99,
        imageUrl:
            'https://images.unsplash.com/photo-1608354580875-30bd4168b351?w=800',
        category: 'Appliances',
        rating: 4.2,
        tags: ['coffee', 'kitchen', 'appliance'],
      ),
      Product(
        id: '6',
        name: 'Running Shoes',
        description: 'Comfortable running shoes with advanced cushioning',
        price: 129.99,
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
        category: 'Fashion',
        rating: 4.4,
        tags: ['shoes', 'running', 'sports'],
      ),
      Product(
        id: '7',
        name: 'Bluetooth Speaker',
        description: 'Portable Bluetooth speaker with deep bass',
        price: 89.99,
        imageUrl:
            'https://images.unsplash.com/photo-1589001181560-a8df1800e501?w=800',
        category: 'Electronics',
        rating: 4.4,
        tags: ['bluetooth', 'speaker', 'audio'],
      ),
      Product(
        id: '8',
        name: 'Digital Camera',
        description: 'Compact digital camera for everyday photography',
        price: 549.99,
        imageUrl:
            'https://images.unsplash.com/photo-1599664223843-9349c75196bc?w=800',
        category: 'Electronics',
        rating: 4.6,
        tags: ['camera', 'photography', 'digital'],
      ),
      Product(
        id: '9',
        name: 'Gaming Keyboard',
        description: 'Mechanical gaming keyboard with RGB lighting',
        price: 129.99,
        imageUrl:
            'https://images.unsplash.com/photo-1637243218672-d338945efdf7?w=800',
        category: 'Electronics',
        rating: 4.5,
        tags: ['gaming', 'keyboard', 'mechanical'],
      ),
      Product(
        id: '10',
        name: 'Office Chair',
        description: 'Ergonomic office chair with lumbar support',
        price: 239.99,
        imageUrl:
            'https://images.unsplash.com/photo-1688578735427-994ecdea3ea4?w=800',
        category: 'Furniture',
        rating: 4.3,
        tags: ['office', 'chair', 'ergonomic'],
      ),
      Product(
        id: '11',
        name: 'Yoga Mat',
        description: 'Non-slip yoga mat for all fitness levels',
        price: 29.99,
        imageUrl:
            'https://images.unsplash.com/photo-1601925268030-e734cf5bdc52?w=800',
        category: 'Fitness',
        rating: 4.8,
        tags: ['yoga', 'fitness', 'mat'],
      ),
      Product(
        id: '12',
        name: 'Electric Kettle',
        description: 'Fast-boil electric kettle with auto shut-off',
        price: 49.99,
        imageUrl:
            'https://images.unsplash.com/photo-1738520420636-a1591b84723e?w=800',
        category: 'Appliances',
        rating: 4.5,
        tags: ['kitchen', 'electric', 'kettle'],
      ),
      Product(
        id: '13',
        name: 'Sunglasses',
        description: 'Polarized sunglasses with UV protection',
        price: 69.99,
        imageUrl:
            'https://images.unsplash.com/photo-1509695507497-903c140c43b0?w=800',
        category: 'Fashion',
        rating: 4.2,
        tags: ['sunglasses', 'fashion', 'uv'],
      ),
      Product(
        id: '14',
        name: 'Desk Lamp',
        description: 'LED desk lamp with adjustable brightness',
        price: 39.99,
        imageUrl:
            'https://images.unsplash.com/photo-1621177555452-bedbe4c28879?w=800',
        category: 'Home',
        rating: 4.6,
        tags: ['lamp', 'led', 'desk'],
      ),
      Product(
        id: '15',
        name: 'Fitness Tracker',
        description: 'Activity & sleep tracker with heart rate monitor',
        price: 99.99,
        imageUrl:
            'https://images.unsplash.com/photo-1532435109783-fdb8a2be0baa?w=800',
        category: 'Electronics',
        rating: 4.3,
        tags: ['fitness', 'tracker', 'health'],
      ),
    ];
  }

  // static List<String> getCategories() {
  //   return ['All', 'Electronics', 'Fashion', 'Accessories', 'Appliances'];
  // }

  static Product getProductById(String id) {
    return getAllProducts().firstWhere(
      (product) => product.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  static List<String> getProductImagesById(String productId) {
    switch (productId) {
      case '1': // Wireless Headphones
        return [
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
          'https://images.unsplash.com/photo-1618366712010-f4ae9c647dcb?w=800',
          'https://images.unsplash.com/photo-1613040809024-b4ef7ba99bc3?w=800',
        ];
      case '2': // Smart Watch
        return [
          'https://images.unsplash.com/photo-1617043786394-f977fa12eddf?w=800',
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800',
          'https://images.unsplash.com/photo-1696688713460-de12ac76ebc6?w=800',
        ];
      case '3': // Laptop Backpack
        return [
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=800',
          'https://plus.unsplash.com/premium_photo-1723649902596-607223a3df2a?w=800',
          'https://images.unsplash.com/photo-1611010344444-5f9e4d86a6e1?w=800',
        ];
      case '4': // Smartphone
        return [
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
          'https://images.unsplash.com/photo-1598965402089-897ce52e8355?w=800',
        ];
      case '5': // Coffee Maker
        return [
          'https://images.unsplash.com/photo-1608354580875-30bd4168b351?w=800',
          'https://images.unsplash.com/photo-1539021897569-06e9fa3c6bb9?w=800',
          'https://images.unsplash.com/photo-1581701663554-291c6c9e56d2?w=800',
        ];
      case '6': // Running Shoes
        return [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
          'https://images.unsplash.com/photo-1585063395665-b8ad4acbb9af?w=800',
          'https://images.unsplash.com/photo-1662037131482-8fb5d10aab9a?w=800',
        ];
      case '7':
        return [
          'https://images.unsplash.com/photo-1589001181560-a8df1800e501?w=800',
          'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=800',
          'https://images.unsplash.com/photo-1589003077984-894e133dabab?w=800',
        ];
      case '8':
        return [
          'https://images.unsplash.com/photo-1599664223843-9349c75196bc?w=800',
          'https://images.unsplash.com/photo-1612232099404-0ca09938afac?w=800',
          'https://images.unsplash.com/photo-1698502453332-03fa2ddceb71?w=800',
        ];
      case '9':
        return [
          'https://images.unsplash.com/photo-1637243218672-d338945efdf7?w=800',
          'https://images.unsplash.com/photo-1544652478-6653e09f18a2?w=800',
          'https://images.unsplash.com/photo-1723124425906-89497cb8a274?w=800',
        ];
      case '10':
        return [
          'https://images.unsplash.com/photo-1688578735427-994ecdea3ea4?w=800',
          'https://plus.unsplash.com/premium_photo-1674049760153-144f4dc9208c?w=800',
          'https://images.unsplash.com/photo-1630266481643-a8a73e78638d?w=800',
        ];
      case '11':
        return [
          'https://images.unsplash.com/photo-1601925268030-e734cf5bdc52?w=800',
          'https://images.unsplash.com/photo-1624651208388-f8726eace8f2?w=800',
          'https://images.unsplash.com/photo-1683758507025-6e74ad3ca1e5?w=800',
        ];
      case '12':
        return [
          'https://images.unsplash.com/photo-1738520420636-a1591b84723e?w=800',
          'https://images.unsplash.com/photo-1633450083431-a111627f6df2?w=800',
          'https://images.unsplash.com/photo-1647619124290-10fb9273b4b5?w=800',
        ];
      case '13':
        return [
          'https://images.unsplash.com/photo-1509695507497-903c140c43b0?w=800',
          'https://images.unsplash.com/photo-1610136649349-0f646f318053?w=800',
          'https://images.unsplash.com/photo-1566421966482-ad8076104d8e?w=800',
        ];
      case '14':
        return [
          'https://images.unsplash.com/photo-1621177555452-bedbe4c28879?w=800',
          'https://images.unsplash.com/photo-1617363020293-62faac14783d?w=800',
          'https://images.unsplash.com/photo-1523380262778-076eb862d38f?w=800',
        ];
      case '15':
        return [
          'https://images.unsplash.com/photo-1532435109783-fdb8a2be0baa?w=800',
          'https://images.unsplash.com/photo-1634341973555-139bf5b9746f?w=800',
          'https://images.unsplash.com/photo-1654195131868-cac1d8429d86?w=800',
        ];
      default:
        return ['https://via.placeholder.com/800x600?text=No+Image+Available'];
    }
  }
}
