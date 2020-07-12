import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResultTab extends StatefulWidget {
  @override
  _ResultTabState createState() => _ResultTabState();
}

class _ResultTabState extends State<ResultTab> {
  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return getDefaultCategoryAxisChart();
  }

  /// Returns the column chart with default category x-axis.
  SfCartesianChart getDefaultCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Internet Users - 2016'),
      plotAreaBorderWidth: 0,

      /// X axis as category axis placed here.
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          minimum: 0, maximum: 80, isVisible: false, labelFormat: '{value}M'),
      series: getDefaultCategory(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> getDefaultCategory() {
    final List<ChartSampleData> chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'South\nKorea', yValue: 39, pointColor: Colors.teal[300]),
      ChartSampleData(
          x: 'India',
          yValue: 20,
          pointColor: const Color.fromRGBO(53, 124, 210, 1)),
      ChartSampleData(x: 'South\nAfrica', yValue: 61, pointColor: Colors.pink),
      ChartSampleData(x: 'China', yValue: 65, pointColor: Colors.orange),
      ChartSampleData(x: 'France', yValue: 45, pointColor: Colors.green),
      ChartSampleData(
          x: 'Saudi\nArabia', yValue: 10, pointColor: Colors.pink[300]),
      ChartSampleData(x: 'Japan', yValue: 16, pointColor: Colors.purple[300]),
      ChartSampleData(
          x: 'Mexico',
          yValue: 31,
          pointColor: const Color.fromRGBO(127, 132, 232, 1))
    ];
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: chartData,
        xValueMapper: (ChartSampleData data, _) => data.x,
        yValueMapper: (ChartSampleData data, _) => data.yValue,
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      )
    ];
  }
}

class ChartSampleData {
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.yValue2,
      this.yValue3,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close});
  final dynamic x;
  final num y;
  final dynamic xValue;
  final num yValue;
  final num yValue2;
  final num yValue3;
  final Color pointColor;
  final num size;
  final String text;
  final num open;
  final num close;
}
