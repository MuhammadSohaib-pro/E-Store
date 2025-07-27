import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_commerece_website_testing/repositories/home_repository.dart';
import 'package:e_commerece_website_testing/models/models.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;

  HomeBloc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository,
      super(HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeScrollPositionChanged>(_onHomeScrollPositionChanged);
    on<HomeRefreshRequested>(_onHomeRefreshRequested);
    on<HomeNewsletterSubscribed>(_onHomeNewsletterSubscribed);
  }

  Future<void> _onHomeInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final futures = await Future.wait([
        _homeRepository.getFeaturedProducts(),
        _homeRepository.getHomeStatistics(),
        _homeRepository.getPromoBanners(),
        _homeRepository.getHeroImages(),
      ]);

      final allProducts = futures[0] as List<Product>;
      final statistics = futures[1] as HomeStatistics;
      final promoBanners = futures[2] as List<PromoBanner>;
      final heroImages = futures[3] as List<String>;

      emit(
        HomeLoaded(
          allProducts: allProducts,
          filteredProducts: allProducts,
          heroImages: heroImages,
          statistics: statistics,
          promoBanners: promoBanners,
        ),
      );
    } catch (e) {
      emit(HomeError(message: 'Failed to load home data: ${e.toString()}'));
    }
  }

  Future<void> _onHomeScrollPositionChanged(
    HomeScrollPositionChanged event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final shouldShowBackToTop = event.offset > 300;

    if (currentState.showBackToTop != shouldShowBackToTop) {
      emit(currentState.copyWith(showBackToTop: shouldShowBackToTop));
    }
  }

  Future<void> _onHomeRefreshRequested(
    HomeRefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    emit(currentState.copyWith(isRefreshing: true));

    try {

      // Reload all data
      final futures = await Future.wait([
        _homeRepository.getFeaturedProducts(),
        _homeRepository.getHomeStatistics(),
        _homeRepository.getPromoBanners(),
        _homeRepository.getHeroImages(),

      ]);

      final allProducts = futures[0] as List<Product>;
      final statistics = futures[1] as HomeStatistics;
      final promoBanners = futures[2] as List<PromoBanner>;
      final heroImages = futures[3] as List<String>;


      emit(
        HomeLoaded(
          allProducts: allProducts,
          filteredProducts: allProducts,
          heroImages: heroImages,
          showBackToTop: currentState.showBackToTop,
          statistics: statistics,
          promoBanners: promoBanners,
          isRefreshing: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isRefreshing: false));
      emit(HomeError(message: 'Failed to refresh data: ${e.toString()}'));
    }
  }

  Future<void> _onHomeNewsletterSubscribed(
    HomeNewsletterSubscribed event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _homeRepository.subscribeToNewsletter(event.email);
      emit(HomeNewsletterSubscribedState(email: event.email));

      // Return to current state
      if (state is HomeLoaded) {
        emit(state as HomeLoaded);
      }
    } catch (e) {
      emit(HomeNewsletterError(message: e.toString()));

      // Return to current state
      if (state is HomeLoaded) {
        emit(state as HomeLoaded);
      }
    }
  }
}
