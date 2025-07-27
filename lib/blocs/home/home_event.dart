import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitialized extends HomeEvent {}

class HomeScrollPositionChanged extends HomeEvent {
  final double offset;

  HomeScrollPositionChanged({required this.offset});

  @override
  List<Object?> get props => [offset];
}

class HomeRefreshRequested extends HomeEvent {}

class HomeNewsletterSubscribed extends HomeEvent {
  final String email;

  HomeNewsletterSubscribed({required this.email});

  @override
  List<Object?> get props => [email];
}
