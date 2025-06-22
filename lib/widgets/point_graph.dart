import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rehab_app2/models/point_model.dart';

class PointGraph extends StatelessWidget {
  final List<PointInfo> points;
  final String title;
  final Color color;
  final double? minY;
  final double? maxY;

  const PointGraph({
    super.key, 
    required this.points, 
    this.color = Colors.blue,
    this.title = '',
    this.minY,
    this.maxY
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
        AspectRatio(
          aspectRatio: 3.0,
          child: LineChart(
            LineChartData(
              maxY: maxY,
              minY: minY,
              lineBarsData: [
                LineChartBarData(
                  spots: points
                      .map((p) => FlSpot(p.x, p.y))
                      .toList(),
                  isCurved: true,
                  dotData: FlDotData(show: false),
                  color: color,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 50), 
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }
}