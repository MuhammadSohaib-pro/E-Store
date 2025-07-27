import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_event.dart';
import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerece_website_testing/repositories/home_repository.dart';

class NewsletterBloc extends Bloc<NewsletterEvent, NewsletterState> {
  final HomeRepository _homeRepository;

  NewsletterBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(NewsletterInitial()) {
    on<NewsletterSubscriptionRequested>(_onNewsletterSubscriptionRequested);
    on<NewsletterFormReset>(_onNewsletterFormReset);
  }

  Future<void> _onNewsletterSubscriptionRequested(
    NewsletterSubscriptionRequested event,
    Emitter<NewsletterState> emit,
  ) async {
    emit(NewsletterLoading());

    try {
      await _homeRepository.subscribeToNewsletter(event.email);
      emit(
        NewsletterSuccess(
          email: event.email,
          message: 'Thank you for subscribing to our newsletter!',
        ),
      );
    } catch (e) {
      emit(NewsletterError(message: e.toString()));
    }
  }

  Future<void> _onNewsletterFormReset(
    NewsletterFormReset event,
    Emitter<NewsletterState> emit,
  ) async {
    emit(NewsletterInitial());
  }
}
