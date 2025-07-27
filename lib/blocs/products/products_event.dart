import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitialized extends ProductsEvent {}


class ProductsRefreshRequested extends ProductsEvent {}