import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/customer/customer_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/bloc/product/product_bloc.dart';
import 'package:frontend_admin/utils/currency_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'dart:math' as math;

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final random = math.Random();
  final List<Color> gradientColors = [const Color(0xff23b6e6), const Color(0xff02d39a)];

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
        padding: const EdgeInsets.all(32),
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
                  child: Icon(Icons.analytics_rounded, color: theme.primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thống kê',
                      style: theme.textTheme.headlineSmall?.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text('Phân tích chi tiết hiệu suất kinh doanh', style: theme.textTheme.titleMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildStatCards(),
            const SizedBox(height: 24),
            _buildCharts(),
            const SizedBox(height: 24),
            _buildTableCard(),
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

  Widget _buildStatCard(String title, Widget value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          value,
        ],
      ),
    );
  }

  Widget _buildCharts() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildLineChartCard()),
        const SizedBox(width: 32),
        Expanded(flex: 1, child: _buildPieChartCard()),
      ],
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Doanh thu theo tháng',
                style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gradientColors[0].withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Năm 2025',
                  style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.black12, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: GoogleFonts.inter(color: Colors.black54, fontSize: 12),
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                      reservedSize: 40,
                      interval: 20,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'T${value.toInt()}',
                            style: GoogleFonts.inter(color: Colors.black54, fontSize: 12),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 1,
                maxX: 12,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, random.nextInt(100).toDouble()),
                      FlSpot(2, random.nextInt(100).toDouble()),
                      FlSpot(3, random.nextInt(100).toDouble()),
                      FlSpot(4, random.nextInt(100).toDouble()),
                      FlSpot(5, random.nextInt(100).toDouble()),
                      FlSpot(6, random.nextInt(100).toDouble()),
                      FlSpot(7, random.nextInt(100).toDouble()),
                      FlSpot(8, random.nextInt(100).toDouble()),
                      FlSpot(9, random.nextInt(100).toDouble()),
                      FlSpot(10, random.nextInt(100).toDouble()),
                      FlSpot(11, random.nextInt(100).toDouble()),
                      FlSpot(12, random.nextInt(100).toDouble()),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(colors: gradientColors),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: gradientColors[1],
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [gradientColors[0].withValues(alpha: 0.3), gradientColors[1].withValues(alpha: 0.1)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChartCard() {
    final List<Color> brandColors = [
      const Color(0xFF3498db), // iPhone - Blue
      const Color(0xFFf39c12), // Samsung - Orange
      const Color(0xFF2ecc71), // Oppo - Green
      const Color(0xFF9b59b6), // Xiaomi - Purple
      const Color(0xFFe74c3c), // Khác - Red
    ];

    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tỉ lệ sản phẩm bán chạy',
            style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: 40,
                          color: brandColors[0],
                          radius: 80,
                          titleStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: 30,
                          color: brandColors[1],
                          radius: 70,
                          titleStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: 15,
                          color: brandColors[2],
                          radius: 65,
                          titleStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: 10,
                          color: brandColors[3],
                          radius: 60,
                          titleStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: 5,
                          color: brandColors[4],
                          radius: 55,
                          titleStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 32,
                      centerSpaceColor: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem('iPhone', '40%', brandColors[0]),
                      const SizedBox(height: 12),
                      _buildLegendItem('Samsung', '30%', brandColors[1]),
                      const SizedBox(height: 12),
                      _buildLegendItem('Oppo', '15%', brandColors[2]),
                      const SizedBox(height: 12),
                      _buildLegendItem('Xiaomi', '10%', brandColors[3]),
                      const SizedBox(height: 12),
                      _buildLegendItem('Khác', '5%', brandColors[4]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(percentage, style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Khách hàng nổi bật',
                style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.indigoAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.indigoAccent.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.people, color: Colors.indigoAccent, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Top 3',
                      style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.1)))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Tên khách hàng',
                      style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Số đơn hàng',
                      style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Tổng chi tiêu',
                      style: GoogleFonts.inter(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildTableRow('Nguyễn Văn A', '12', '20.000.000 đ', Colors.amber),
          _buildTableRow('Trần Thị B', '8', '12.000.000 đ', Colors.grey),
          _buildTableRow('Lê Văn C', '5', '7.000.000 đ', Colors.brown),
        ],
      ),
    );
  }

  Widget _buildTableRow(String name, String orders, String spending, Color medalColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black.withValues(alpha: 0.05)))),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: medalColor.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: Center(child: Icon(Icons.emoji_events, size: 16, color: medalColor)),
                ),
                const SizedBox(width: 12),
                Text(name, style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  orders,
                  style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              spending,
              style: GoogleFonts.inter(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
