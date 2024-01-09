import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Screens/Authetication_Screens/login_screen.dart';
import 'package:sensor_mapping/Screens/Home_Screens/setting_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:geekyants_flutter_gauges/geekyants_flutter_gauges.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  height: 20,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'pH',
                            style: TextStyle(
                              fontSize:
                                  20, // You can adjust the font size as needed
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                              height:
                                  10), // Adjust the spacing between the title and the gauge

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
                            pointers: const [
                              Pointer(
                                value: 7.0,
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
                            pointers: const [
                              MarkerPointer(
                                value: 50,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
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
                                  '90.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                            pointers: const [
                              MarkerPointer(
                                value: 50,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
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
                                  '90.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                            pointers: const [
                              MarkerPointer(
                                value: 50,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
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
                                  '90.0',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 2000,
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
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 500,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 500,
                                  endValue: 2000,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: const [
                              MarkerPointer(
                                value: 500,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  'mg/kg',
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
                                  '500',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                    // Phosphorous
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
                          text: 'Phosphorous',
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 2000,
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
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 500,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 500,
                                  endValue: 2000,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: const [
                              MarkerPointer(
                                value: 500,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  'mg/kg',
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
                                  '500',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
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
                            maximum: 2000,
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
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 500,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 500,
                                  endValue: 2000,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: const [
                              MarkerPointer(
                                value: 500,
                                markerHeight: 15,
                                color: Colors.black,
                              ),
                            ],
                            annotations: const <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  'mg/kg',
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
                                  '500.0',
                                  style: TextStyle(
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
