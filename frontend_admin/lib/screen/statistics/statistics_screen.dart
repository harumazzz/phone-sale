import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        color: Colors.white.withValues(alpha: 0.04),
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
          Text(title, style: GoogleFonts.inter(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLineChartCard() {
    final Color gradientColor1 = Color(0xFF23b6e6);
    final Color gradientColor2 = Color(0xFF02d39a);

    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
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
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: gradientColor1.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Năm 2025',
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
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
                    return FlLine(color: Colors.white10, strokeWidth: 1);
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
                            style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
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
                            style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
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
                    gradient: LinearGradient(colors: [gradientColor1, gradientColor2]),
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 3,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: gradientColor2,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [gradientColor1.withValues(alpha: 0.3), gradientColor2.withValues(alpha: 0.1)],
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
      Color(0xFF3498db), // iPhone - Blue
      Color(0xFFf39c12), // Samsung - Orange
      Color(0xFF2ecc71), // Oppo - Green
      Color(0xFF9b59b6), // Xiaomi - Purple
      Color(0xFFe74c3c), // Khác - Red
    ];

    return Container(
      height: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tỉ lệ sản phẩm bán chạy',
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
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
                      SizedBox(height: 12),
                      _buildLegendItem('Samsung', '30%', brandColors[1]),
                      SizedBox(height: 12),
                      _buildLegendItem('Oppo', '15%', brandColors[2]),
                      SizedBox(height: 12),
                      _buildLegendItem('Xiaomi', '10%', brandColors[3]),
                      SizedBox(height: 12),
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
        SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        const Spacer(),
        Text(percentage, style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTableCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
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
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
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
                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)))),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Tên khách hàng',
                      style: GoogleFonts.inter(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Số đơn hàng',
                      style: GoogleFonts.inter(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Tổng chi tiêu',
                      style: GoogleFonts.inter(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.w500),
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
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
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
                Text(name, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  orders,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              spending,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
