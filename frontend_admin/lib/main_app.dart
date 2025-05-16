import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/interceptors/error_handling_service.dart';
import 'package:frontend_admin/repository/category_repository.dart';
import 'package:frontend_admin/repository/customer_repository.dart';
import 'package:frontend_admin/repository/order_repository.dart';
import 'package:frontend_admin/repository/product_repository.dart';
import 'package:frontend_admin/service/service_locator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

import 'bloc/category/category_bloc.dart';
import 'bloc/product/product_bloc.dart';
import 'constant/color_constant.dart';
import 'constant/theme.dart';
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
  final ErrorHandlingService _errorHandlingService = ErrorHandlingService();

  @override
  void initState() {
    _controller = SidebarXController(selectedIndex: 0, extended: true);
    _key = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the current context for error handling
    _errorHandlingService.setContext(context);
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
        title: 'PhoneSale Admin',
        debugShowCheckedModeBanner: false,
        theme: MaterialDesign.lightTheme,
        home: Builder(
          builder: (context) {
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Scaffold(
              key: _key,
              appBar:
                  isSmallScreen
                      ? AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        title: Text(
                          'PhoneSale',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.primaryColor,
                            fontSize: 22,
                          ),
                        ),
                        leading: IconButton(
                          onPressed: () {
                            _key.currentState?.openDrawer();
                          },
                          icon: Icon(Icons.menu, color: ColorConstant.primaryColor),
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_outlined),
                            color: Colors.grey[800],
                          ),
                          const SizedBox(width: 8),
                        ],
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
