import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:e_store/repositories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _searchRepository;
  Timer? _searchTimer;

  SearchBloc({required SearchRepository searchRepository})
    : _searchRepository = searchRepository,
      super(SearchInitial()) {
    on<SearchInitialized>(_onSearchInitialized);
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer:
          (events, mapper) => events
              .debounceTime(const Duration(milliseconds: 500))
              .asyncExpand(mapper),
    );
    on<SearchQueryCleared>(_onSearchQueryCleared);
    on<SearchFilterApplied>(_onSearchFilterApplied);
    on<SearchSortChanged>(_onSearchSortChanged);
    on<SearchHistoryItemSelected>(_onSearchHistoryItemSelected);
    on<SearchSuggestionSelected>(_onSearchSuggestionSelected);
    on<SearchCategorySelected>(_onSearchCategorySelected);
    on<SearchHistoryCleared>(_onSearchHistoryCleared);
    on<SearchFocusChanged>(_onSearchFocusChanged);
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }

  Future<void> _onSearchInitialized(
    SearchInitialized event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final searchHistory = _searchRepository.searchHistory;
      final suggestedSearches = _searchRepository.suggestedSearches;

      emit(
        SearchEmpty(
          searchHistory: searchHistory,
          suggestedSearches: suggestedSearches,
        ),
      );
    } catch (e) {
      emit(
        SearchError(message: 'Failed to initialize search: ${e.toString()}'),
      );
    }
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      final searchHistory = _searchRepository.searchHistory;
      final suggestedSearches = _searchRepository.suggestedSearches;

      emit(
        SearchEmpty(
          searchHistory: searchHistory,
          suggestedSearches: suggestedSearches,
          hasFocus:
              state is SearchEmpty ? (state as SearchEmpty).hasFocus : false,
        ),
      );
      return;
    }

    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(isSearching: true, query: query));
    }

    await _performSearch(query, emit);
  }

  Future<void> _performSearch(String query, Emitter<SearchState> emit) async {
    try {
      await _searchRepository.addToSearchHistory(query);

      final searchResults = await _searchRepository.searchProducts(query);

      if (searchResults.isEmpty) {
        final suggestedSearches = await _searchRepository.getSearchSuggestions(
          query,
        );
        emit(
          SearchNoResults(query: query, suggestedSearches: suggestedSearches),
        );
        return;
      }

      final searchState = SearchLoaded(
        query: query,
        searchResults: searchResults,
        filteredResults: searchResults,
        selectedFilters: [],
        sortBy: 'relevance',
      );

      emit(searchState);
    } catch (e) {
      emit(
        SearchError(message: 'Search failed: ${e.toString()}', query: query),
      );
    }
  }

  Future<void> _onSearchQueryCleared(
    SearchQueryCleared event,
    Emitter<SearchState> emit,
  ) async {
    _searchTimer?.cancel();

    final searchHistory = _searchRepository.searchHistory;
    final suggestedSearches = _searchRepository.suggestedSearches;

    emit(
      SearchEmpty(
        searchHistory: searchHistory,
        suggestedSearches: suggestedSearches,
      ),
    );
  }

  Future<void> _onSearchFilterApplied(
    SearchFilterApplied event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) return;

    final currentState = state as SearchLoaded;

    try {
      final filteredProducts = await _searchRepository.filterProducts(
        currentState.searchResults,
        event.selectedFilters,
      );

      final sortedProducts = await _searchRepository.sortProducts(
        filteredProducts,
        currentState.sortBy,
      );

      emit(
        currentState.copyWith(
          selectedFilters: event.selectedFilters,
          filteredResults: sortedProducts,
        ),
      );
    } catch (e) {
      emit(
        SearchError(
          message: 'Failed to apply filters: ${e.toString()}',
          query: currentState.query,
        ),
      );
    }
  }

  Future<void> _onSearchSortChanged(
    SearchSortChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state is! SearchLoaded) return;

    final currentState = state as SearchLoaded;

    try {
      final sortedProducts = await _searchRepository.sortProducts(
        currentState.filteredResults,
        event.sortBy,
      );

      emit(
        currentState.copyWith(
          sortBy: event.sortBy,
          filteredResults: sortedProducts,
        ),
      );
    } catch (e) {
      emit(
        SearchError(
          message: 'Failed to sort results: ${e.toString()}',
          query: currentState.query,
        ),
      );
    }
  }

  Future<void> _onSearchHistoryItemSelected(
    SearchHistoryItemSelected event,
    Emitter<SearchState> emit,
  ) async {
    add(SearchQueryChanged(query: event.query));
  }

  Future<void> _onSearchSuggestionSelected(
    SearchSuggestionSelected event,
    Emitter<SearchState> emit,
  ) async {
    add(SearchQueryChanged(query: event.suggestion));
  }

  Future<void> _onSearchCategorySelected(
    SearchCategorySelected event,
    Emitter<SearchState> emit,
  ) async {
    add(SearchQueryChanged(query: event.category.toLowerCase()));
  }

  Future<void> _onSearchHistoryCleared(
    SearchHistoryCleared event,
    Emitter<SearchState> emit,
  ) async {
    try {
      await _searchRepository.clearSearchHistory();

      if (state is SearchEmpty) {
        final currentState = state as SearchEmpty;
        emit(currentState.copyWith(searchHistory: []));
      }
    } catch (e) {
      emit(SearchError(message: 'Failed to clear history: ${e.toString()}'));
    }
  }

  Future<void> _onSearchFocusChanged(
    SearchFocusChanged event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchEmpty) {
      final currentState = state as SearchEmpty;
      emit(currentState.copyWith(hasFocus: event.hasFocus));
    }
  }
}
