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
    _SalesData('En', 20),
    _SalesData('Fe', 28),
    _SalesData('Ma', 34),
    _SalesData('Ab', 32),
    _SalesData('Ma', 40),
    _SalesData('Ju', 40),
    _SalesData('Ju', 40),
    _SalesData('Ag', 80),
    _SalesData('Se', 10),
    _SalesData('Oc', 100),
    _SalesData('No', 60),
    _SalesData('Di', 40)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bodyColor,
        body: Center(
          child: SizedBox(
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
