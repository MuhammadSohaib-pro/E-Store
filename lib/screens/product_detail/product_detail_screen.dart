import 'package:auto_route/auto_route.dart';
import 'package:e_commerece_website_testing/blocs/cart/cart_bloc.dart';
import 'package:e_commerece_website_testing/blocs/cart/cart_event.dart';
import 'package:e_commerece_website_testing/blocs/product_detail/product_detail_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_detail/product_detail_event.dart';
import 'package:e_commerece_website_testing/blocs/product_detail/product_detail_state.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_event.dart';
import 'package:e_commerece_website_testing/models/models.dart';
import 'package:e_commerece_website_testing/screens/product_detail/components/components.dart';
import 'package:e_commerece_website_testing/utils/utils.dart';
import 'package:e_commerece_website_testing/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    @PathParam('id') required this.productId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _imageController;
  late AnimationController _contentController;
  late AnimationController _fabController;

  late Animation<double> _imageAnimation;
  late Animation<double> _contentAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProductDetails();
  }

  void _initializeAnimations() {
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _imageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _imageController, curve: Curves.easeOut));

    _contentAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.elasticOut),
    );

    _startAnimations();
  }

  void _loadProductDetails() {
    context.read<ProductDetailBloc>().add(
      ProductDetailLoadRequested(productId: widget.productId),
    );
    context.read<ProductSpecificationsBloc>().add(
      ProductSpecificationsLoadRequested(productId: widget.productId),
    );
  }

  void _startAnimations() async {
    _imageController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _contentController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _fabController.forward();
  }

  @override
  void didUpdateWidget(covariant ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productId != widget.productId) {
      _loadProductDetails();
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    _contentController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listener: _handleProductDetailStateChanges,
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return _buildLoadingState();
          }

          if (state is ProductDetailError) {
            return _buildErrorState(state.message);
          }

          if (state is ProductDetailLoaded) {
            return Responsive(
              mobile: _buildMobileLayout(state),
              desktop: _buildDesktopLayout(state),
            );
          }

          return _buildLoadingState();
        },
      ),
      floatingActionButton: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoaded && !Responsive.isDesktop(context)) {
            return _buildFloatingActionButton(state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleProductDetailStateChanges(
    BuildContext context,
    ProductDetailState state,
  ) {
    if (state is ProductAddedToCartSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${state.quantity} x ${state.product.name} added to cart',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: SnackBarAction(
            label: 'View Cart',
            onPressed: () => AutoRouter.of(context).pushPath('/cart'),
          ),
        ),
      );
    } else if (state is ProductFavoriteUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.isFavorite ? 'Added to favorites' : 'Removed from favorites',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (state is ProductDetailError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Product Details'),
      ),
      body: const Center(
        child: LoadingWidget(message: 'Loading product details...'),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Product Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: Colors.red.shade400),
              const SizedBox(height: 24),
              Text(
                'Failed to load product',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadProductDetails,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(ProductDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        ProductDetailAppBar(
          product: state.product,
          isFavorite: state.isFavorite,
          onFavoriteToggled: () => _toggleFavorite(),
          onShare: () => _showShareDialog(state.product),
        ),
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _contentAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _contentAnimation.value),
                child: Column(
                  children: [
                    ProductImageGallery(
                      images: state.productImages,
                      selectedIndex: state.selectedImageIndex,
                      onImageChanged: (index) => _changeImage(index),
                      animation: _imageAnimation,
                    ),
                    ProductInfoSection(
                      product: state.product,
                      quantity: state.quantity,
                      showFullDescription: state.showFullDescription,
                      onQuantityChanged:
                          (quantity) => _changeQuantity(quantity),
                      onDescriptionToggled: () => _toggleDescription(),
                    ),
                    ProductSpecificationsSection(),
                    ProductReviewsSection(),
                    RelatedProductsSection(
                      products: state.relatedProducts,
                      isLoading: state.relatedProductsLoading,
                    ),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(ProductDetailLoaded state) {
    return CustomScrollView(
      slivers: [
        ProductDetailAppBar(
          product: state.product,
          isFavorite: state.isFavorite,
          onFavoriteToggled: () => _toggleFavorite(),
          onShare: () => _showShareDialog(state.product),
        ),
        SliverToBoxAdapter(
          child: AnimatedBuilder(
            animation: _contentAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _contentAnimation.value),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: ProductImageGallery(
                              images: state.productImages,
                              selectedIndex: state.selectedImageIndex,
                              onImageChanged: (index) => _changeImage(index),
                              animation: _imageAnimation,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            flex: 1,
                            child: ProductInfoSection(
                              product: state.product,
                              quantity: state.quantity,
                              showFullDescription: state.showFullDescription,
                              isDesktop: true,
                              onQuantityChanged:
                                  (quantity) => _changeQuantity(quantity),
                              onDescriptionToggled: () => _toggleDescription(),
                              onAddToCart: () => _addToCart(state),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      ProductSpecificationsSection(),
                      const SizedBox(height: 40),
                      ProductReviewsSection(),
                      const SizedBox(height: 40),
                      RelatedProductsSection(
                        products: state.relatedProducts,
                        isLoading: state.relatedProductsLoading,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(ProductDetailLoaded state) {
    return ScaleTransition(
      scale: _fabAnimation,
      child: FloatingActionButton.extended(
        onPressed: () => _addToCart(state),
        icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
        label: Text(
          'Add to Cart - \$${(state.product.price * state.quantity).toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _changeQuantity(int quantity) {
    context.read<ProductDetailBloc>().add(
      ProductQuantityChanged(quantity: quantity),
    );
  }

  void _changeImage(int index) {
    context.read<ProductDetailBloc>().add(
      ProductImageChanged(imageIndex: index),
    );
  }

  void _toggleFavorite() {
    context.read<ProductDetailBloc>().add(ProductFavoriteToggled());
  }

  void _toggleDescription() {
    context.read<ProductDetailBloc>().add(ProductDescriptionToggled());
  }

  void _addToCart(ProductDetailLoaded state) {
    context.read<CartBloc>().add(
      CartItemAdded(product: state.product, quantity: state.quantity),
    );
  }

  void _showShareDialog(Product product) {
    showDialog(
      context: context,
      builder: (context) => ShareProductDialog(product: product),
    );
  }
}
