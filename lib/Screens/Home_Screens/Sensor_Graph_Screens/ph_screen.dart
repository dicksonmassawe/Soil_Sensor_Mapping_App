import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}