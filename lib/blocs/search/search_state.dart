import 'package:equatable/equatable.dart';
import 'package:e_store/models/models.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchEmpty extends SearchState {
  final List<String> searchHistory;
  final List<String> suggestedSearches;
  final bool hasFocus;

  SearchEmpty({
    required this.searchHistory,
    required this.suggestedSearches,
    this.hasFocus = false,
  });

  SearchEmpty copyWith({
    List<String>? searchHistory,
    List<String>? suggestedSearches,
    List<String>? categories,
    bool? hasFocus,
  }) {
    return SearchEmpty(
      searchHistory: searchHistory ?? this.searchHistory,
      suggestedSearches: suggestedSearches ?? this.suggestedSearches,
      hasFocus: hasFocus ?? this.hasFocus,
    );
  }

  @override
  List<Object?> get props => [searchHistory, suggestedSearches, hasFocus];
}

class SearchLoaded extends SearchState {
  final String query;
  final List<Product> searchResults;
  final List<Product> filteredResults;
  final List<String> selectedFilters;
  final String sortBy;
  final bool isSearching;
  final bool hasSearched;

  SearchLoaded({
    required this.query,
    required this.searchResults,
    required this.filteredResults,
    required this.selectedFilters,
    required this.sortBy,
    this.isSearching = false,
    this.hasSearched = true,
  });

  SearchLoaded copyWith({
    String? query,
    List<Product>? searchResults,
    List<Product>? filteredResults,
    List<String>? availableFilters,
    List<String>? selectedFilters,
    String? sortBy,
    bool? isSearching,
    bool? hasSearched,
  }) {
    return SearchLoaded(
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
      filteredResults: filteredResults ?? this.filteredResults,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      sortBy: sortBy ?? this.sortBy,
      isSearching: isSearching ?? this.isSearching,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props => [
    query,
    searchResults,
    filteredResults,
    selectedFilters,
    sortBy,
    isSearching,
    hasSearched,
  ];
}

class SearchError extends SearchState {
  final String message;
  final String? query;

  SearchError({required this.message, this.query});

  @override
  List<Object?> get props => [message, query];
}

class SearchNoResults extends SearchState {
  final String query;
  final List<String> suggestedSearches;

  SearchNoResults({required this.query, required this.suggestedSearches});

  @override
  List<Object?> get props => [query, suggestedSearches];
}
