import 'package:flutter/material.dart';

// Transition Time in millisecond
int transitionTime = 500;

class MyUtility {
  BuildContext context;

  MyUtility(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}
