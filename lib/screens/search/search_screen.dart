// lib/screens/search_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:e_commerece_website_testing/blocs/search/search_bloc.dart';
import 'package:e_commerece_website_testing/blocs/search/search_event.dart';
import 'package:e_commerece_website_testing/blocs/search/search_state.dart';
import 'package:e_commerece_website_testing/screens/search/components/components.dart';
import 'package:e_commerece_website_testing/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;
  late AnimationController _filterAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSearch();
    _setupFocusListener();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  void _initializeSearch() {
    context.read<SearchBloc>().add(SearchInitialized());
    
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  void _setupFocusListener() {
    _searchFocusNode.addListener(() {
      context.read<SearchBloc>().add(
        SearchFocusChanged(hasFocus: _searchFocusNode.hasFocus),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Column(
                children: [
                  SearchBarWidget(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (query) => _onSearchQueryChanged(query),
                    onClear: () => _onSearchCleared(),
                  ),
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return _buildSearchContent(state);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Search Products',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      actions: [
        BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            final hasQuery = _searchController.text.isNotEmpty;
            if (!hasQuery) return const SizedBox(width: 16);

            return IconButton(
              onPressed: _onSearchCleared,
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchContent(SearchState state) {
    if (state is SearchLoading) {
      return const Center(
        child: LoadingWidget(message: 'Searching products...'),
      );
    }

    if (state is SearchError) {
      return SearchErrorWidget(
        message: state.message,
        query: state.query,
        onRetry: () => _retrySearch(state.query),
      );
    }

    if (state is SearchEmpty) {
      return SearchEmptyWidget(
        searchHistory: state.searchHistory,
        suggestedSearches: state.suggestedSearches,
        hasFocus: state.hasFocus,
        onHistoryItemSelected: (query) => _selectSearchItem(query),
        onSuggestionSelected: (suggestion) => _selectSearchItem(suggestion),
        onCategorySelected: (category) => _selectCategory(category),
        onHistoryCleared: () => _clearHistory(),
      );
    }

    if (state is SearchNoResults) {
      return SearchNoResultsWidget(
        query: state.query,
        suggestedSearches: state.suggestedSearches,
        onSuggestionSelected: (suggestion) => _selectSearchItem(suggestion),
      );
    }

    if (state is SearchLoaded) {
      return Column(
        children: [
          SearchResultsHeader(
            query: state.query,
            resultCount: state.filteredResults.length,
            sortBy: state.sortBy,
            onSortChanged: (sortBy) => _changeSorting(sortBy),
          ),
          if (state.filteredResults.isNotEmpty)
            SearchFiltersSection(
              selectedFilters: state.selectedFilters,
              onFiltersChanged: (filters) => _applyFilters(filters),
            ),
          Expanded(
            child: SearchResultsGrid(
              products: state.filteredResults,
              isLoading: state.isSearching,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  void _onSearchQueryChanged(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query: query));
  }

  void _onSearchCleared() {
    _searchController.clear();
    context.read<SearchBloc>().add(SearchQueryCleared());
  }

  void _selectSearchItem(String query) {
    _searchController.text = query;
    _searchFocusNode.unfocus();
    context.read<SearchBloc>().add(SearchHistoryItemSelected(query: query));
  }

  void _selectCategory(String category) {
    _searchController.text = category.toLowerCase();
    _searchFocusNode.unfocus();
    context.read<SearchBloc>().add(SearchCategorySelected(category: category));
  }

  void _clearHistory() {
    context.read<SearchBloc>().add(SearchHistoryCleared());
  }

  void _applyFilters(List<String> filters) {
    context.read<SearchBloc>().add(SearchFilterApplied(selectedFilters: filters));
  }

  void _changeSorting(String sortBy) {
    context.read<SearchBloc>().add(SearchSortChanged(sortBy: sortBy));
  }

  void _retrySearch(String? query) {
    if (query != null) {
      _searchController.text = query;
      context.read<SearchBloc>().add(SearchQueryChanged(query: query));
    }
  }
}