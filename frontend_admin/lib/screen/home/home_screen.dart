import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/bloc/product/product_bloc.dart';
import 'package:frontend_admin/custom_screen.dart';
import 'package:frontend_admin/utils/currency_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final random = math.Random();
  List<Color> gradientColors = [const Color(0xff23b6e6), const Color(0xff02d39a)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(const LoadProductEvent());
      context.read<CustomerBloc>().add(const LoadCustomerEvent());
      context.read<OrderBloc>().add(const LoadOrderEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.dashboard_rounded, color: theme.primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text('Chào mừng đến với trang quản trị', style: theme.textTheme.titleMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildStatCards(),
            const SizedBox(height: 24),
            _buildCharts(),
            const SizedBox(height: 24),
            _buildRecentOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Tổng sản phẩm',
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded) {
                  return Text(
                    '${state.products.length}',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                  );
                }
                return const SizedBox(height: 32, width: 32, child: CircularProgressIndicator(strokeWidth: 2));
              },
            ),
            Symbols.shopping_bag,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Khách hàng',
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                if (state is CustomerLoaded) {
                  return Text(
                    '${state.customers.length}',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            Symbols.group,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Đơn hàng',
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoaded) {
                  return Text(
                    '${state.orders.length}',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            Symbols.receipt_long,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Doanh thu',
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoaded) {
                  final totalRevenue = state.orders.fold(0.0, (sum, order) => sum + (order.totalPrice ?? 0));
                  return Text(
                    CurrencyUtils.formatVnd(totalRevenue),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            Symbols.payments,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, Widget content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Icon(Symbols.trending_up, color: Colors.green[400], size: 20),
              const SizedBox(width: 4),
              Text(
                '+${random.nextInt(20) + 5}%',
                style: TextStyle(color: Colors.green[400], fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doanh thu theo tháng',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const months = [
                                  'T1',
                                  'T2',
                                  'T3',
                                  'T4',
                                  'T5',
                                  'T6',
                                  'T7',
                                  'T8',
                                  'T9',
                                  'T10',
                                  'T11',
                                  'T12',
                                ];
                                if (value.toInt() >= 0 && value.toInt() < months.length) {
                                  return Text(
                                    months[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(12, (index) {
                              return FlSpot(index.toDouble(), random.nextDouble() * 100000);
                            }),
                            isCurved: true,
                            gradient: LinearGradient(colors: gradientColors),
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: gradientColors.map((color) => color.withValues(alpha: 0.3)).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phân loại sản phẩm',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: const Color(0xff0293ee),
                            value: 30,
                            title: 'iPhone',
                            radius: 80,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: const Color(0xfff8b250),
                            value: 25,
                            title: 'Samsung',
                            radius: 70,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: const Color(0xff845bef),
                            value: 20,
                            title: 'Xiaomi',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: const Color(0xff13d38e),
                            value: 15,
                            title: 'Oppo',
                            radius: 50,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: const Color(0xffe15258),
                            value: 10,
                            title: 'Khác',
                            radius: 40,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn hàng gần đây',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to Orders screen
                    final controller = context.findAncestorWidgetOfExactType<CustomScreen>()?.controller;
                    if (controller != null) {
                      controller.selectIndex(5);
                    }
                  },
                  icon: const Icon(Symbols.visibility),
                  label: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoaded) {
                  final recentOrders = state.orders.take(5).toList();
                  return Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 1)),
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Mã đơn',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Khách hàng',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Ngày đặt',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Tổng tiền',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Trạng thái',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (final order in recentOrders)
                        TableRow(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey.shade800, width: 0.5)),
                          ),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  '#${order.orderId}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(order.customerId ?? 'N/A', style: TextStyle(color: Colors.grey[300])),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  order.orderDate != null ? DateFormat('dd/MM/yyyy').format(order.orderDate!) : 'N/A',
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(
                                  CurrencyUtils.formatVnd(order.totalPrice ?? 0),
                                  style: TextStyle(color: Colors.grey[300]),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: const Text(
                                    'Hoàn thành',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
