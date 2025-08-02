import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/home/home_bloc.dart';
import 'package:e_store/blocs/home/home_event.dart';
import 'package:e_store/blocs/home/home_state.dart';
import 'package:e_store/screens/home/components/components.dart';
import 'package:e_store/utils/utils.dart';
import 'package:e_store/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fabController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupScrollListener();
    _loadHomeData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      context.read<HomeBloc>().add(
        HomeScrollPositionChanged(offset: _scrollController.offset),
      );
    });
  }

  void _loadHomeData() {
    context.read<HomeBloc>().add(HomeInitialized());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomAppBar(),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: _handleHomeStateChanges,
        builder: (context, state) {
          return Stack(
            children: [_buildMainContent(state), _buildBackToTopButton(state)],
          );
        },
      ),
    );
  }

  void _handleHomeStateChanges(BuildContext context, HomeState state) {
    if (state is HomeNewsletterSubscribed) {
      _showSuccessSnackBar('Thank you for subscribing!');
    } else if (state is HomeNewsletterError) {
      _showErrorSnackBar(state.message);
    } else if (state is HomeError) {
      _showErrorSnackBar(state.message);
    }
  }

  Widget _buildMainContent(HomeState state) {
    if (state is HomeLoading) {
      return const Center(
        child: LoadingWidget(message: 'Loading home data...'),
      );
    }

    if (state is HomeError) {
      return HomeErrorWidget(
        message: state.message,
        onRetry: () => _loadHomeData(),
      );
    }

    if (state is HomeLoaded) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Responsive(
                mobile: _buildMobileLayout(state),
                desktop: _buildDesktopLayout(state),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildMobileLayout(HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeRefreshRequested());
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: HeroSection(heroImages: state.heroImages),
            ),
          ),
          SliverToBoxAdapter(
            child: HomeFeaturedBanners(
              banners: state.promoBanners,
              onBannerTapped: (banner) {},
            ),
          ),
          SliverToBoxAdapter(
            child: HomeQuickStats(statistics: state.statistics),
          ),
          SliverToBoxAdapter(child: HomeProductsHeader()),
          SliverToBoxAdapter(
            child: ProductGrid(
              products: state.filteredProducts,
              isLoading: state.isRefreshing,
            ),
          ),
          SliverToBoxAdapter(child: HomeNewsletterSection()),
          SliverToBoxAdapter(child: HomeFooterSection()),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(HomeLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeRefreshRequested());
      },
      child: Row(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: HeroSection(heroImages: state.heroImages),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: HomeQuickStats(statistics: state.statistics),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: HomeFeaturedBanners(
                      banners: state.promoBanners,
                      onBannerTapped: (banner) {},
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: HomeProductsHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: ProductGrid(
                      products: state.filteredProducts,
                      isLoading: state.isRefreshing,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: HomeNewsletterSection(),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 50)),
                SliverToBoxAdapter(child: HomeFooterSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToTopButton(HomeState state) {
    if (state is! HomeLoaded || !state.showBackToTop) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 30,
      right: 30,
      child: AnimatedScale(
        scale: state.showBackToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton(
          onPressed: _scrollToTop,
          backgroundColor: Theme.of(
            context,
          ).primaryColor.withValues(alpha: 0.9),
          foregroundColor: Colors.white,
          elevation: 4,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
