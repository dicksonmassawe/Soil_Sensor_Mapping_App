import 'package:flutter/material.dart';
import 'package:sensor_mapping/Screens/Authetication_Screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sensor_mapping/Theme/theme_provider.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeProvider(), child: const SensorMapping()),
  );
}

class SensorMapping extends StatelessWidget {
  const SensorMapping({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
