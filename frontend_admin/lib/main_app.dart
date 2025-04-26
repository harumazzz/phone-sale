import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/repository/category_repository.dart';
import 'package:frontend_admin/repository/customer_repository.dart';
import 'package:frontend_admin/repository/order_repository.dart';
import 'package:frontend_admin/repository/product_repository.dart';
import 'package:frontend_admin/service/service_locator.dart';
import 'package:sidebarx/sidebarx.dart';

import 'bloc/category/category_bloc.dart';
import 'bloc/product/product_bloc.dart';
import 'constant/color_constant.dart';
import 'custom_screen.dart';
import 'custom_sidebar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late SidebarXController _controller;

  late GlobalKey<ScaffoldState> _key;

  @override
  void initState() {
    _controller = SidebarXController(selectedIndex: 0, extended: true);
    _key = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(categoryRepository: ServiceLocator.get<CategoryRepository>()),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository: ServiceLocator.get<ProductRepository>()),
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => CustomerBloc(customerRepository: ServiceLocator.get<CustomerRepository>()),
        ),
        BlocProvider<OrderBloc>(create: (context) => OrderBloc(orderRepository: ServiceLocator.get<OrderRepository>())),
      ],
      child: MaterialApp(
        title: 'Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          primaryColor: ColorConstant.primaryColor,
          canvasColor: ColorConstant.canvasColor,
          scaffoldBackgroundColor: ColorConstant.scaffoldBackgroundColor,
          textTheme: const TextTheme(
            headlineSmall: TextStyle(color: Colors.white, fontSize: 46, fontWeight: FontWeight.w800),
          ),
        ),
        home: Builder(
          builder: (context) {
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Scaffold(
              key: _key,
              appBar:
                  isSmallScreen
                      ? AppBar(
                        backgroundColor: ColorConstant.canvasColor,
                        title: const Text('Admin'),
                        leading: IconButton(
                          onPressed: () {
                            _key.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        ),
                      )
                      : null,
              drawer: CustomSidebar(controller: _controller),
              body: Row(
                children: [
                  if (!isSmallScreen) CustomSidebar(controller: _controller),
                  Expanded(child: Center(child: CustomScreen(controller: _controller))),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
