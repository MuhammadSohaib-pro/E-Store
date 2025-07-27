import 'package:equatable/equatable.dart';

abstract class NewsletterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsletterSubscriptionRequested extends NewsletterEvent {
  final String email;

  NewsletterSubscriptionRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class NewsletterFormReset extends NewsletterEvent {}
