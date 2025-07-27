import 'package:equatable/equatable.dart';

abstract class NewsletterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsletterInitial extends NewsletterState {}

class NewsletterLoading extends NewsletterState {}

class NewsletterSuccess extends NewsletterState {
  final String email;
  final String message;

  NewsletterSuccess({required this.email, required this.message});

  @override
  List<Object?> get props => [email, message];
}

class NewsletterError extends NewsletterState {
  final String message;

  NewsletterError({required this.message});

  @override
  List<Object?> get props => [message];
}