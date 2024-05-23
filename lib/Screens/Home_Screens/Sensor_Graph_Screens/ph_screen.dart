import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/temperature_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/home_screen.dart';

class PhScreen extends StatefulWidget {
  final double ph;
  final double second;

  const PhScreen({super.key, required this.ph, required this.second});

  @override
  State<PhScreen> createState() => _PhScreenState();
}

class _PhScreenState extends State<PhScreen> {
  // List to hold chart data
  late List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();

    // Update chart data
    chartData.add(FlSpot(widget.second, widget.ph));

    // Remove old data to keep the list size constant
    if (chartData.length > 60) {
      chartData.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                // Top icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                          child: const HomeScreen(),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: transitionTime),
                          reverseDuration: Duration(seconds: transitionTime),
                        ));
                      },
                      icon: Icon(
                        FlutterRemix.arrow_left_line,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                    ),
                    Text(
                      'pH Graph ${widget.second}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: 3.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigate to Login screen
                        Navigator.of(context).push(PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const TemperatureScreen(),
                          duration: Duration(milliseconds: transitionTime),
                          reverseDuration:
                              Duration(milliseconds: transitionTime),
                        ));
                      },
                      icon: Icon(
                        FlutterRemix.arrow_right_line,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 600,
                  padding: const EdgeInsets.all(20),
                  child: LineChart(
                    LineChartData(
                      minX: 1,
                      maxX: 60, // Assuming 24 hours, 1440 minutes
                      minY: 1,
                      maxY: 14,
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(
                            axisNameWidget: Text('pH Value'),
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 28,
                            )),
                        bottomTitles: AxisTitles(
                            axisNameWidget: Text('Time'),
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                            )),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Theme.of(context).textTheme.bodyLarge?.color ??
                              Colors.black,
                        ),
                      ),
                      gridData: const FlGridData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: chartData,
                          isCurved: true,
                          color: Colors.blue,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
