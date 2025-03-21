import 'package:flutter/material.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/cart_bloc/cart_bloc.dart';
import 'bloc/category_bloc/category_bloc.dart';
import 'bloc/order_bloc/order_bloc.dart';
import 'bloc/payment_bloc/payment_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
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
import 'screen/home_screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'service/service_locator.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) {
            final bloc = CategoryBloc(
              categoryRepository: ServiceLocator.get<CategoryRepository>(),
            );
            bloc.add(const LoadCategoryEvent());
            return bloc;
          },
        ),
        BlocProvider<ProductBloc>(
          create: (context) {
            final bloc = ProductBloc(
              productRepository: ServiceLocator.get<ProductRepository>(),
            );
            bloc.add(const ProductFetch());
            return bloc;
          },
        ),
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc(
              authRepository: ServiceLocator.get<AuthRepository>(),
            );
          },
        ),
        BlocProvider<CartBloc>(
          create: (context) {
            return CartBloc(
              cartRepository: ServiceLocator.get<CartRepository>(),
            );
          },
        ),
        BlocProvider<PaymentBloc>(
          create: (context) {
            return PaymentBloc(
              paymentRepository: ServiceLocator.get<PaymentRepository>(),
            );
          },
        ),
        BlocProvider<OrderBloc>(
          create: (context) {
            return OrderBloc(
              orderRepository: ServiceLocator.get<OrderRepository>(),
            );
          },
        ),
        BlocProvider<ShipmentBloc>(
          create: (context) {
            return ShipmentBloc(
              shipmentRepository: ServiceLocator.get<ShipmentRepository>(),
            );
          },
        ),
        BlocProvider<WishlistBloc>(
          create: (context) {
            return WishlistBloc(
              wishlistRepository: ServiceLocator.get<WishlistRepository>(),
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
