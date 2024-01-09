import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Screens/Home_Screens/home_screen.dart';
import 'package:sensor_mapping/Theme/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
//Get user email from Firebase
  final user = FirebaseAuth.instance.currentUser!;

  // Icon size
  double iconSize = 30;

  // Check Theme
  bool isLight = false;

  // ListTile text style
  TextStyle styledText() {
    return TextStyle(
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontSize: 20,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
    );
  }

  // Add the ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Add a variable to store the selected image file
  File? _selectedImage;

  Future<void> _onImageButtonPressed(
    ImageSource source, {
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        // maxWidth: 800, // Adjust this value based on your requirements
        // maxHeight: 800, // Adjust this value based on your requirements
        // imageQuality: 85, // Adjust this value based on your requirements
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onPanUpdate: (details) {
          // Check if the user swipes from right to left
          if (details.delta.dx < 0) {
            Navigator.of(context).push(PageTransition(
              child: const HomeScreen(),
              type: PageTransitionType.rightToLeft,
              duration: Duration(milliseconds: transitionTime),
              reverseDuration: Duration(milliseconds: transitionTime),
            ));
          }
        },
        child: Container(
          height: MyUtility(context).height,
          width: MyUtility(context).width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MyUtility(context).height * 0.30,
                  child: DrawerHeader(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/maize.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            backgroundImage: _selectedImage == null
                                ? null
                                : FileImage(_selectedImage!),
                            child: _selectedImage == null
                                ? Icon(
                                    FlutterRemix.image_line,
                                    size: 50,
                                    color: Theme.of(context).iconTheme.color,
                                  )
                                : null,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _onImageButtonPressed(ImageSource.camera,
                                      context: context);
                                },
                                icon: const Icon(FlutterRemix.camera_line),
                                iconSize: 20,
                                color: Palettes.textColor4,
                              ),
                              IconButton(
                                onPressed: () {
                                  _onImageButtonPressed(ImageSource.gallery,
                                      context: context);
                                },
                                icon: const Icon(
                                    FlutterRemix.gallery_upload_line),
                                iconSize: 20,
                                color: Palettes.textColor4,
                              ),
                            ],
                          ),
                          Text(
                            user.email!,
                            style: const TextStyle(
                                color: Palettes.textColor4, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.account_circle_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Account Info',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.lock_2_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Security',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                Divider(
                  color: Theme.of(context).iconTheme.color,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.sensor_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Soil Sensor',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                Divider(
                  color: Theme.of(context).iconTheme.color,
                  thickness: 1.0,
                ),
                SwitchListTile(
                  secondary: Icon(
                    FlutterRemix.moon_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Dark Mode',
                    style: styledText(),
                  ),
                  value: isLight,
                  onChanged: (bool value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                    setState(() {
                      isLight = value;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.global_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Language',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                Divider(
                  color: Theme.of(context).iconTheme.color,
                  thickness: 1.0,
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.questionnaire_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Help Center',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.customer_service_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'Support',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    FlutterRemix.shield_star_fill,
                    color: Theme.of(context).iconTheme.color,
                    size: iconSize,
                  ),
                  title: Text(
                    'About',
                    style: styledText(),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
