import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Screens/Authetication_Screens/login_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/conductivity_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/humidity_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/nitrogen_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/ph_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/phosphorus_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/potassium_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/Sensor_Graph_Screens/temperature_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/setting_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Map<String, dynamic> sensor = {};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  int month = 01;
  String day = "Sunday";
  int date = 01;
  int hour = 01;
  int minute = 01;
  String fMonth = "";
  String fDate = "";
  String fHour = "";
  String fMinute = "";

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
        fMonth = month < 10 ? '0$month' : '$month';
        day = sensor['client']['day'];
        date = (sensor['client']['date'] as num).toInt();
        fDate = date < 10 ? '0$date' : '$date';
        hour = (sensor['client']['hour'] as num).toInt();
        fHour = hour < 10 ? '0$hour' : '$hour';
        minute = (sensor['client']['minute'] as num).toInt();
        fMinute = minute < 10 ? '0$minute' : '$minute';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Container width
    double containerWidth = (MyUtility(context).width - 60) / 2;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                // Top Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(PageTransition(
                          child: const SettingScreen(),
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: transitionTime),
                          reverseDuration: Duration(seconds: transitionTime),
                        ));
                      },
                      icon: Icon(
                        FlutterRemix.settings_5_line,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        letterSpacing: 3.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Log out of Firebase
                        FirebaseAuth.instance.signOut();
                        // Navigate to Login screen
                        Navigator.of(context).push(PageTransition(
                          type: PageTransitionType.fade,
                          child: const LoginScreen(),
                          duration: const Duration(seconds: 1),
                          reverseDuration: const Duration(seconds: 1),
                        ));
                      },
                      icon: Icon(
                        FlutterRemix.logout_circle_r_line,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '$day, $fHour:$fMinute',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      '$fDate/$fMonth/$year ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // Sensor value containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 100,
                      width: MyUtility(context).width - 40,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const PhScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            child: const Text(
                              'pH',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Palettes.textColor6,
                              ),
                            ),
                          ),
                          // const SizedBox(height: 10),
                          LinearGauge(
                            start: 1,
                            end: 14,
                            steps: 2,
                            gaugeOrientation: GaugeOrientation.horizontal,
                            enableGaugeAnimation: true,
                            rulers: RulerStyle(
                              rulerPosition: RulerPosition.bottom,
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            pointers: [
                              Pointer(
                                value: ph,
                                height: 15,
                                shape: PointerShape.triangle,
                                color: Colors.black,
                              ),
                            ],
                            linearGaugeBoxDecoration:
                                const LinearGaugeBoxDecoration(
                              thickness: 5,
                              linearGradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.pink,
                                  Colors.orange,
                                  Colors.orangeAccent,
                                  Colors.yellow,
                                  Colors.greenAccent,
                                  Colors.greenAccent,
                                  Colors.green,
                                  Colors.green,
                                  Colors.blueAccent,
                                  Colors.blueAccent,
                                  Colors.blue,
                                  Colors.purpleAccent,
                                  Colors.purple,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Temperature
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Temperature',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const TemperatureScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 25,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 25,
                                  endValue: 45,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 45,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: temperature,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  '°C',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  temperature.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Humidity
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Humidity',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const HumidityScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 25,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 25,
                                  endValue: 60,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 60,
                                  endValue: 100,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: humidity,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  humidity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Sensor value containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Conductivity
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Conductivity',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const ConductivityScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 4,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 4,
                                  endValue: 10,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 10,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: conductivity,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  'dS/m',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  conductivity.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Nitrogen
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Nitrogen',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 2,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const NitrogenScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 0.4,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.4,
                                  endValue: 0.8,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.8,
                                  endValue: 2,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: nitrogen,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  nitrogen.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Sensor value containers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // phosphorus
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Phosphorus',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 2,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const PhosphorusScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 0.4,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.4,
                                  endValue: 0.8,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.8,
                                  endValue: 2,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: phosphorus,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  phosphorus.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Potassium
                    Container(
                      height: containerWidth,
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Palettes.inputContainerColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Palettes.shadowColor.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: SfRadialGauge(
                        title: const GaugeTitle(
                          text: 'Potassium',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Palettes.textColor6,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 2,
                            startAngle: 140,
                            endAngle: 40,
                            showLastLabel: true,
                            minorTicksPerInterval: 10,
                            majorTickStyle: const MajorTickStyle(
                              length: 8,
                              color: Colors.blue,
                              thickness: 2,
                            ),
                            minorTickStyle: const MinorTickStyle(
                              length: 4,
                              color: Colors.blue,
                              thickness: 1,
                            ),
                            axisLabelStyle: const GaugeTextStyle(
                              color: Palettes.textColor6,
                            ),
                            onAxisTapped: (value) {
                              Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.fade,
                                child: const PotassiumScreen(),
                                duration:
                                    Duration(milliseconds: transitionTime),
                                reverseDuration:
                                    Duration(milliseconds: transitionTime),
                              ));
                            },
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 0.4,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.4,
                                  endValue: 0.8,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 0.8,
                                  endValue: 2,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: [
                              MarkerPointer(
                                value: potassium,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: <GaugeAnnotation>[
                              const GaugeAnnotation(
                                widget: Text(
                                  '%',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.1,
                              ),
                              GaugeAnnotation(
                                widget: Text(
                                  potassium.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Palettes.textColor6,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.9,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
