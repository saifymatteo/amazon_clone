import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CategoryProductChart extends StatelessWidget {
  const CategoryProductChart({super.key, required this.seriesList});

  final List<charts.Series<Sales, String>> seriesList;

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
