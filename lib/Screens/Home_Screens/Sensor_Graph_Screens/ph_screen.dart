import 'dart:async';
import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/temperature_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/home_screen.dart';

class PhScreen extends StatefulWidget {
  const PhScreen({super.key});

  @override
  State<PhScreen> createState() => _PhScreenState();
}

class _PhScreenState extends State<PhScreen> {
  late Timer _timer;

  double ph = 7.0;
  double alititude = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;
  double nitrogen = 0.0;
  double phosphorus = 0.0;
  double potassium = 0.0;
  double conductivity = 0.0;
  double temperature = 0.0;
  double humidity = 0.0;
  int year = 2024;
  int month = 1;
  String day = "Sunday";
  int date = 1;
  int hour = 1;
  int minute = 1;

  // List to hold chart data
  List<FlSpot> chartData = [];

  @override
  void initState() {
    super.initState();
    // Initial API call
    apicall();
    // Setting up a periodic timer for API updates every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      apicall();
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse(
        "http://45.61.55.203:9090/api/v1/XAjieqa2LNFTIvyasBki/attributes?clientKeys="));

    if (response.statusCode == 200) {
      setState(() {
        // Parse the JSON data
        sensor = json.decode(response.body);

        // Access the specific parameter
        alititude = (sensor['client']['altitude'] as num).toDouble();
        latitude = (sensor['client']['latitude'] as num).toDouble();
        longitude = (sensor['client']['longitude'] as num).toDouble();
        ph = (sensor['client']['ph'] as num).toDouble();
        temperature = (sensor['client']['temperature'] as num).toDouble();
        humidity = (sensor['client']['humidity'] as num).toDouble();
        conductivity = (sensor['client']['conductivity'] as num).toDouble();
        nitrogen = (sensor['client']['nitrogen'] as num).toDouble();
        phosphorus = (sensor['client']['phosphorus'] as num).toDouble();
        potassium = (sensor['client']['potassium'] as num).toDouble();
        year = (sensor['client']['year'] as num).toInt();
        month = (sensor['client']['month'] as num).toInt();
        day = sensor['client']['day'];
        date = (sensor['client']['date'] as num).toInt();
        hour = (sensor['client']['hour'] as num).toInt();
        minute = (sensor['client']['minute'] as num).toInt();

        // Get current time in minutes
        int currentTime = hour * 60 + minute;
        print(currentTime);

        // Add new data point to chartData
        chartData.add(FlSpot(currentTime.toDouble(), ph));

        // Remove previous data points if needed to keep the chart concise
        // if (chartData.length > 50) {
        //   chartData.removeAt(0);
        // }
      });
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
                      'pH Graph',
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
                      minX: 0,
                      maxX: 1440, // Assuming 24 hours, 1440 minutes
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
