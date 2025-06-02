import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/discount/discount_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/interceptors/error_handling_service.dart';
import 'package:frontend_admin/repository/category_repository.dart';
import 'package:frontend_admin/repository/customer_repository.dart';
import 'package:frontend_admin/repository/discount_repository.dart';
import 'package:frontend_admin/repository/order_repository.dart';
import 'package:frontend_admin/repository/product_repository.dart';
import 'package:frontend_admin/service/service_locator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../bloc/category/category_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../constant/color_constant.dart';
import '../../custom_screen.dart';
import '../../custom_sidebar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
        BlocProvider<DiscountBloc>(
          create: (context) => DiscountBloc(discountRepository: ServiceLocator.get<DiscountRepository>()),
        ),
      ],
      child: Builder(
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
                          onPressed: () {
                            // Show logout dialog
                            _showLogoutDialog(context);
                          },
                          icon: const Icon(Icons.logout),
                          color: Colors.grey[800],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.grey[800],
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                    : AppBar(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'PhoneSale Admin Dashboard',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                color: ColorConstant.primaryColor,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _showLogoutDialog(context);
                            },
                            icon: const Icon(Icons.logout),
                            color: Colors.grey[800],
                            tooltip: 'Logout',
                          ),
                        ],
                      ),
                    ),
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
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Navigate back to login screen
                Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
