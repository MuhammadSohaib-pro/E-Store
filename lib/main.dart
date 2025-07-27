import 'package:e_commerece_website_testing/blocs/cart/cart_bloc.dart';
import 'package:e_commerece_website_testing/blocs/cart/cart_event.dart';
import 'package:e_commerece_website_testing/blocs/home/home_bloc.dart';
import 'package:e_commerece_website_testing/blocs/home/home_event.dart';
import 'package:e_commerece_website_testing/blocs/newsletter/newsletter_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_detail/product_detail_bloc.dart';
import 'package:e_commerece_website_testing/blocs/product_specifications/product_specifications_bloc.dart';
import 'package:e_commerece_website_testing/blocs/products/products_bloc.dart';
import 'package:e_commerece_website_testing/blocs/products/products_event.dart';
import 'package:e_commerece_website_testing/blocs/search/search_bloc.dart';
import 'package:e_commerece_website_testing/firebase_options.dart';
import 'package:e_commerece_website_testing/repositories/cart_repository.dart';
import 'package:e_commerece_website_testing/repositories/home_repository.dart';
import 'package:e_commerece_website_testing/repositories/product_detail_repository.dart';
import 'package:e_commerece_website_testing/repositories/products_repository.dart';
import 'package:e_commerece_website_testing/repositories/search_repository.dart';
import 'package:e_commerece_website_testing/routes/app_router.dart';
import 'package:e_commerece_website_testing/services/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Load environment variables
  if (kDebugMode) {
    await dotenv.load(fileName: ".env");
  }
  // Initialize Stripe service
  StripeWebService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter().config();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<CartRepository>(
          create: (context) => CartRepository(),
        ),
        RepositoryProvider<ProductDetailRepository>(
          create: (context) => ProductDetailRepository(),
        ),
        RepositoryProvider<SearchRepository>(
          create: (context) => SearchRepository(),
        ),
        RepositoryProvider<HomeRepository>(
          create: (context) => HomeRepository(),
        ),
        RepositoryProvider<ProductsRepository>(
          create: (context) => ProductsRepository(),
        ),
        // Add other repositories here as we create them
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CartBloc>(
            create:
                (context) =>
                    CartBloc(cartRepository: context.read<CartRepository>())
                      ..add(CartLoadRequested()),
          ),
          BlocProvider<ProductDetailBloc>(
            create:
                (context) => ProductDetailBloc(
                  productDetailRepository:
                      context.read<ProductDetailRepository>(),
                  cartRepository: context.read<CartRepository>(),
                ),
          ),
          BlocProvider<ProductSpecificationsBloc>(
            create:
                (context) => ProductSpecificationsBloc(
                  repository: context.read<ProductDetailRepository>(),
                ),
          ),
          BlocProvider<SearchBloc>(
            create:
                (context) => SearchBloc(
                  searchRepository: context.read<SearchRepository>(),
                ),
          ),
          BlocProvider<HomeBloc>(
            create:
                (context) =>
                    HomeBloc(homeRepository: context.read<HomeRepository>())
                      ..add(HomeInitialized()),
          ),
          BlocProvider<NewsletterBloc>(
            create:
                (context) => NewsletterBloc(
                  homeRepository: context.read<HomeRepository>(),
                ),
          ),
          BlocProvider<ProductsBloc>(
            create:
                (context) => ProductsBloc(
                  productRepository: context.read<ProductsRepository>(),
                )..add(ProductsInitialized()),
          ),

          // Add other BLoCs here as we create them
        ],
        child: MaterialApp.router(
          routerConfig: router,
          title: 'E-Store',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    const primaryColor = Color(0xFF2D3748);
    const accentColor = Color(0xFF4299E1);
    const backgroundColor = Color(0xFFF7FAFC);

    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Inter',

      // Color scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
        onSurface: backgroundColor,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: primaryColor),
      ),

      // Card theme
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        color: Colors.white,
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: primaryColor,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryColor,
          fontFamily: 'Inter',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: primaryColor,
          fontFamily: 'Inter',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: primaryColor,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
