import 'package:equatable/equatable.dart';

class HomeStatistics extends Equatable {
  final String totalProducts;
  final String totalCustomers;
  final String averageRating;
  final String supportAvailability;

  const HomeStatistics({
    required this.totalProducts,
    required this.totalCustomers,
    required this.averageRating,
    required this.supportAvailability,
  });

  @override
  List<Object?> get props => [
        totalProducts,
        totalCustomers,
        averageRating,
        supportAvailability,
      ];
}