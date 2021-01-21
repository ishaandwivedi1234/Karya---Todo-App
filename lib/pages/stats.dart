import 'package:bezier_chart/bezier_chart.dart';
import 'package:circle_wave_progress/circle_wave_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:karya/model/task.dart';
import 'package:karya/widgets/appBar.dart';
import 'package:karya/widgets/colors.dart';
import 'package:karya/widgets/text.dart';

class Stats extends StatefulWidget {
  List<Task> todayTasks;
  Stats({this.todayTasks});
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  double percent = 1;
  int taskCount = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: customAppBar("My Stats", true),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                // color: Colors.green[300],
                elevation: 20.0,
                child: Center(
                  child: Container(
                    height: 300.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        T("Todays Progress ", 16.0),
                        SizedBox(height: 20.0),
                        CircleWaveProgress(
                          size: 200,
                          borderWidth: 10.0,
                          backgroundColor: decentYellow,
                          borderColor: Colors.transparent,
                          waveColor:
                              Colors.green.withOpacity(.5).withAlpha(100),
                          progress: percent,
                        ),
                        SizedBox(height: 20.0),
                        T(
                            "Total " +
                                taskCount.toString() +
                                " tasks out of " +
                                "15 tasks are completed = " +
                                percent.toString() +
                                " %",
                            12.0)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Card(
                elevation: 20.0,
                child: Center(
                  child: Container(
                    height: 300.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        T("Last Week ", 16.0),
                        SizedBox(height: 20.0),
                        Expanded(
                          child: BezierChart(
                              bezierChartScale: BezierChartScale.CUSTOM,
                              xAxisCustomValues: const [1, 2, 3, 4, 5, 6, 6, 7],
                              series: const [
                                BezierLine(
                                  data: const [
                                    DataPoint<double>(value: 10, xAxis: 1),
                                    DataPoint<double>(value: 130, xAxis: 2),
                                    DataPoint<double>(value: 50, xAxis: 3),
                                    DataPoint<double>(value: 150, xAxis: 4),
                                    DataPoint<double>(value: 75, xAxis: 5),
                                    DataPoint<double>(value: 0, xAxis: 6),
                                    DataPoint<double>(value: 5, xAxis: 7),
                                    DataPoint<double>(value: 45, xAxis: 35),
                                  ],
                                ),
                              ],
                              config: BezierChartConfig(
                                verticalIndicatorStrokeWidth: 3.0,
                                verticalIndicatorColor: Colors.black26,
                                showVerticalIndicator: true,
                                backgroundColor: Colors.red,
                                snap: false,
                              )),
                        ),
                        SizedBox(height: 20.0),
                        T(
                            "Total " +
                                taskCount.toString() +
                                " tasks out of " +
                                "15 tasks are completed = " +
                                percent.toString() +
                                " %",
                            12.0)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
