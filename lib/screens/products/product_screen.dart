import 'package:auto_route/auto_route.dart';
import 'package:e_store/blocs/products/products_bloc.dart';
import 'package:e_store/blocs/products/products_event.dart';
import 'package:e_store/blocs/products/products_state.dart';
import 'package:e_store/screens/home/components/home_error_widget.dart';
import 'package:e_store/utils/responsive.dart';
import 'package:e_store/widgets/loading_widget.dart';
import 'package:e_store/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    _loadProductsData();
  }

  void _loadProductsData() {
    context.read<ProductsBloc>().add(ProductsInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("All Products"),
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(
              child: LoadingWidget(message: 'Loading home data...'),
            );
          }

          if (state is ProductsError) {
            return HomeErrorWidget(
              message: state.message,
              onRetry: () => _loadProductsData(),
            );
          }
          if (state is ProductsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductsBloc>().add(ProductsRefreshRequested());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile(context) ? 16 : 32,
                ),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ProductGrid(products: state.allProducts),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
