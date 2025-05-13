import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thống kê', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Phân tích chi tiết hiệu suất kinh doanh', style: theme.textTheme.titleMedium),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Tổng sản phẩm', '49', Icons.shopping_bag, Colors.blue),
              _buildStatCard('Khách hàng mới', '5', Icons.person_add, Colors.orange),
              _buildStatCard('Đơn hàng mới', '3', Icons.receipt_long, Colors.green),
              _buildStatCard('Tỉ lệ chuyển đổi', '12%', Icons.trending_up, Colors.purple),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildLineChartCard()),
              const SizedBox(width: 32),
              Expanded(flex: 1, child: _buildPieChartCard()),
            ],
          ),
          const SizedBox(height: 32),
          _buildTableCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontSize: 16, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doanh thu theo tháng',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget:
                          (value, meta) =>
                              Text('T${value.toInt()}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
                      FlSpot(1, 20),
                      FlSpot(2, 60),
                      FlSpot(3, 80),
                      FlSpot(4, 90),
                      FlSpot(5, 70),
                      FlSpot(6, 60),
                      FlSpot(7, 40),
                      FlSpot(8, 30),
                      FlSpot(9, 20),
                      FlSpot(10, 40),
                      FlSpot(11, 60),
                      FlSpot(12, 100),
                    ],
                    isCurved: true,
                    color: Colors.cyanAccent,
                    barWidth: 4,
                    dotData: FlDotData(show: false),
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
    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tỉ lệ sản phẩm bán chạy',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(value: 40, color: Colors.blue, title: 'iPhone'),
                  PieChartSectionData(value: 30, color: Colors.orange, title: 'Samsung'),
                  PieChartSectionData(value: 15, color: Colors.green, title: 'Oppo'),
                  PieChartSectionData(value: 10, color: Colors.purple, title: 'Xiaomi'),
                  PieChartSectionData(value: 5, color: Colors.red, title: 'Khác'),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Khách hàng nổi bật',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Tên khách hàng', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('Số đơn hàng', style: TextStyle(color: Colors.white70))),
              DataColumn(label: Text('Tổng chi tiêu', style: TextStyle(color: Colors.white70))),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('Nguyễn Văn A', style: TextStyle(color: Colors.white))),
                  DataCell(Text('12', style: TextStyle(color: Colors.white))),
                  DataCell(Text('20.000.000 đ', style: TextStyle(color: Colors.white))),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Trần Thị B', style: TextStyle(color: Colors.white))),
                  DataCell(Text('8', style: TextStyle(color: Colors.white))),
                  DataCell(Text('12.000.000 đ', style: TextStyle(color: Colors.white))),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('Lê Văn C', style: TextStyle(color: Colors.white))),
                  DataCell(Text('5', style: TextStyle(color: Colors.white))),
                  DataCell(Text('7.000.000 đ', style: TextStyle(color: Colors.white))),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
