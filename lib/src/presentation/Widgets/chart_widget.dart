import 'package:flutter/material.dart';
import 'package:loan_app/src/utils/constans.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({Key? key}) : super(key: key);

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<_SalesData> data = [
    _SalesData('Ene', 35),
    _SalesData('Feb', 28),
    _SalesData('Mar', 34),
    _SalesData('Ab', 32),
    _SalesData('Ma', 40),
    _SalesData('Jun', 40),
    _SalesData('Jul', 40),
    _SalesData('Ago', 80),
    _SalesData('Sep', 10),
    _SalesData('Oct', 100),
    _SalesData('Nov', 60),
    _SalesData('Dic', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: Center(
          child: Container(
            height: 300,
            width: double.infinity,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                // Enable legend
                legend: const Legend(isVisible: true),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_SalesData, String>>[
                  StackedColumnSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.year,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: '',
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
                ]),
          ),
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
