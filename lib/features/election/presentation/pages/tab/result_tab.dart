import 'dart:async';

import 'package:evoting/core/utils/app_config.dart';
import 'package:evoting/features/election/domain/entities/candidate_response.dart';
import 'package:evoting/features/election/presentation/bloc/election_detail_bloc/election_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web3dart/web3dart.dart';

class ResultTab extends StatefulWidget {
  final FetchAnElectionCompleted electionResponse;

  const ResultTab({this.electionResponse});
  @override
  _ResultTabState createState() => _ResultTabState();
}

class _ResultTabState extends State<ResultTab> {
  int touchedIndex;
  StreamSubscription<FilterEvent> electionResultEvent;

  Map<String, ChartSampleData> candidateResults = {};

  @override
  void initState() {
    getElectionResult();
    super.initState();
  }

  void getElectionResult() async {
    final DeployedContract contract =
        await AppConfig.contract.then((value) => value);

    final getElectionResult = contract.function("getElectionResult");
    List<dynamic> candidateListRaw = [];
    await AppConfig().ethClient().call(
        contract: contract,
        function: getElectionResult,
        params: [widget.electionResponse.election.electionId]).then((value) {
      candidateListRaw = value.first;
    });
    for (var i = 0; i < candidateListRaw.length; i++) {
      CandidateResponse candidateResponse =
          CandidateResponse.fromMap([candidateListRaw[i]]);
      setState(() {
        candidateResults[candidateResponse.candidateId] = ChartSampleData(
            x: candidateResponse.candidateName,
            yValue: candidateResponse.voter.length,
            pointColor: Colors.teal[300]);
      });
    }
    print(candidateResults);

    final candidateResultEvent = contract.event('ElectionResult');
    electionResultEvent = AppConfig()
        .ethClient()
        .events(FilterOptions.events(
            contract: contract, event: candidateResultEvent))
        .listen((event) {
      setState(() {
        final decoded =
            candidateResultEvent.decodeResults(event.topics, event.data);
        print(decoded);
        setState(() {
          candidateResults[decoded[0]] = ChartSampleData(
              x: decoded[2],
              yValue: int.parse(decoded[1].toString()),
              pointColor: Colors.teal[300]);
        });
      });
    });
  }

  @override
  void dispose() {
    electionResultEvent.asFuture();
    electionResultEvent.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getDefaultCategoryAxisChart();
  }

  /// Returns the column chart with default category x-axis.
  SfCartesianChart getDefaultCategoryAxisChart() {
    return SfCartesianChart(
      title: ChartTitle(text: 'Live Election Result'),
      plotAreaBorderWidth: 0,

      /// X axis as category axis placed here.
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          minimum: 0,
          maximum:
              widget.electionResponse.election.approvedVoter.length.toDouble(),
          isVisible: false,
          labelFormat: '{value} Votes'),
      series: getDefaultCategory(),
      tooltipBehavior:
          TooltipBehavior(enable: true, header: '', canShowMarker: false),
    );
  }

  /// Returns the list of chart series which need to render on the column chart.
  List<ColumnSeries<ChartSampleData, String>> getDefaultCategory() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: candidateResults.values.toList(),
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

// ChartSampleData(
//           x: 'India',
//           yValue: 20,
//           pointColor: const Color.fromRGBO(53, 124, 210, 1)),
//       ChartSampleData(x: 'South\nAfrica', yValue: 61, pointColor: Colors.pink),
//       ChartSampleData(x: 'China', yValue: 65, pointColor: Colors.orange),
//       ChartSampleData(x: 'France', yValue: 45, pointColor: Colors.green),
//       ChartSampleData(
//           x: 'Saudi\nArabia', yValue: 10, pointColor: Colors.pink[300]),
//       ChartSampleData(x: 'Japan', yValue: 16, pointColor: Colors.purple[300]),
//       ChartSampleData(
//           x: 'Mexico',
//           yValue: 31,
//           pointColor: const Color.fromRGBO(127, 132, 232, 1))
