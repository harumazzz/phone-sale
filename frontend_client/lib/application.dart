import 'package:flutter/material.dart';

import 'bloc/category_bloc/category_bloc.dart';
import 'bloc/product_bloc/product_bloc.dart';
import 'repository/category_repository.dart';
import 'repository/product_repository.dart';
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
            return ProductBloc(
              productRepository: ServiceLocator.get<ProductRepository>(),
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
