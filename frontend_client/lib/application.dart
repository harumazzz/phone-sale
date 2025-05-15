import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/category_bloc/category_bloc.dart';
import 'bloc/category_search_bloc/category_search_bloc.dart';
import 'bloc/order_bloc/order_bloc.dart';
import 'bloc/payment_bloc/payment_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
import 'bloc/product_search_bloc/product_search_bloc.dart';
import 'bloc/shipment_bloc/shipment_bloc.dart';
import 'bloc/wishlist_bloc/wishlist_bloc.dart';
import 'repository/auth_repository.dart';
import 'repository/cart_repository.dart';
import 'repository/category_repository.dart';
import 'repository/order_repository.dart';
import 'repository/payment_repository.dart';
import 'repository/product_repository.dart';
import 'repository/shipment_repository.dart';
import 'repository/wishlist_repository.dart';
import 'screen/log_in/login_screen.dart';
import 'service/custom_observer.dart';
import 'service/service_locator.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) {
            return CategoryBloc(categoryRepository: ServiceLocator.get<CategoryRepository>());
          },
        ),
        BlocProvider<ProductBloc>(
          create: (context) {
            return ProductBloc(productRepository: ServiceLocator.get<ProductRepository>());
          },
        ),
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc(authRepository: ServiceLocator.get<AuthRepository>());
          },
        ),
        BlocProvider<CartBloc>(
          create: (context) {
            return CartBloc(
              cartRepository: ServiceLocator.get<CartRepository>(),
              productRepository: ServiceLocator.get<ProductRepository>(),
            );
          },
        ),
        BlocProvider<ProductSearchBloc>(
          create: (context) {
            return ProductSearchBloc(productRepository: ServiceLocator.get<ProductRepository>());
          },
        ),
        BlocProvider<PaymentBloc>(
          create: (context) {
            return PaymentBloc(paymentRepository: ServiceLocator.get<PaymentRepository>());
          },
        ),
        BlocProvider<OrderBloc>(
          create: (context) {
            return OrderBloc(orderRepository: ServiceLocator.get<OrderRepository>());
          },
        ),
        BlocProvider<ShipmentBloc>(
          create: (context) {
            return ShipmentBloc(shipmentRepository: ServiceLocator.get<ShipmentRepository>());
          },
        ),
        BlocProvider<WishlistBloc>(
          create: (context) {
            return WishlistBloc(wishlistRepository: ServiceLocator.get<WishlistRepository>());
          },
        ),
        BlocProvider<CategorySearchBloc>(
          create: (context) {
            return CategorySearchBloc(productRepository: ServiceLocator.get<ProductRepository>());
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            navigatorObservers: [
              CustomNavigatorObserver(
                onPop: () {
                  context.read<ProductBloc>().add(const ProductFetch());
                },
              ),
            ],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF536DFE),
                primary: const Color(0xFF536DFE),
                secondary: const Color(0xFF03DAC6),
              ),
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              cardTheme: CardTheme(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                iconTheme: IconThemeData(color: Color(0xFF536DFE)),
                titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
                titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                bodyLarge: GoogleFonts.inter(fontSize: 16, color: Colors.black87),
                bodyMedium: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
              ),
              buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                buttonColor: const Color(0xFF536DFE),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF536DFE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              pageTransitionsTheme: PageTransitionsTheme(
                builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
                  TargetPlatform.values,
                  value: (_) => const FadeForwardsPageTransitionsBuilder(),
                ),
              ),
              progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0xFF536DFE)),
            ),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
