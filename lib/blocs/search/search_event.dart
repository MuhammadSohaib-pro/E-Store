import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitialized extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  
  SearchQueryChanged({required this.query});
  
  @override
  List<Object?> get props => [query];
}

class SearchQueryCleared extends SearchEvent {}

class SearchFilterApplied extends SearchEvent {
  final List<String> selectedFilters;
  
  SearchFilterApplied({required this.selectedFilters});
  
  @override
  List<Object?> get props => [selectedFilters];
}

class SearchSortChanged extends SearchEvent {
  final String sortBy;
  
  SearchSortChanged({required this.sortBy});
  
  @override
  List<Object?> get props => [sortBy];
}

class SearchHistoryItemSelected extends SearchEvent {
  final String query;
  
  SearchHistoryItemSelected({required this.query});
  
  @override
  List<Object?> get props => [query];
}

class SearchSuggestionSelected extends SearchEvent {
  final String suggestion;
  
  SearchSuggestionSelected({required this.suggestion});
  
  @override
  List<Object?> get props => [suggestion];
}

class SearchCategorySelected extends SearchEvent {
  final String category;
  
  SearchCategorySelected({required this.category});
  
  @override
  List<Object?> get props => [category];
}

class SearchHistoryCleared extends SearchEvent {}

class SearchFocusChanged extends SearchEvent {
  final bool hasFocus;
  
  SearchFocusChanged({required this.hasFocus});
  
  @override
  List<Object?> get props => [hasFocus];
}