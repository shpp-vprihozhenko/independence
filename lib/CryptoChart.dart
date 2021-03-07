import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class CryptoChartData {
  String dt;
  double rate;
  charts.Color barColor = charts.ColorUtil.fromDartColor(Colors.blue);

  CryptoChartData(this.dt, this.rate);
}

class CryptoChart extends StatelessWidget {
  final List<CryptoChartData> data;

  CryptoChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<CryptoChartData, String>> series = [
      charts.Series(
        data: data,
        id: "Crypto",
        domainFn: (CryptoChartData series, _) => series.dt,
        measureFn: (CryptoChartData series, _) => series.rate,
        colorFn: (CryptoChartData series, _) => series.barColor,
      )
    ];
    return charts.BarChart(
      series,
      animate: false,
      primaryMeasureAxis: charts.NumericAxisSpec(tickProviderSpec: charts.BasicNumericTickProviderSpec(zeroBound: false)),
      domainAxis: new charts.OrdinalAxisSpec(
        // Make sure that we draw the domain axis line.
          showAxisLine: true,
          // But don't draw anything else.
          renderSpec: new charts.NoneRenderSpec()
      ),
      //defaultRenderer: ,
      //domainAxis: charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      //primaryMeasureAxis: charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
      //flipVerticalAxis: true,
    );
  }
}