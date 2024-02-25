import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Constants/validate_credential.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // Input Container dimensions
  double inputContainerHeight = 250;
  double inputContainerWidth = 350;

  //Controllers
  TextEditingController emailController = TextEditingController();

  //Credential Validator
  String? emailValidator(String? value) {
    return EmailValidator.validateEmail(value);
  }

  // Variable to check credential validation
  final _formKey = GlobalKey<FormState>();

  //Submitting Function
  void _submit() async {
    // Check if field entities have pass the requirements
    if (!_formKey.currentState!.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState!.save();

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        );
      },
    );

    // Recover password
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      // Pop the loading circle
      Navigator.pop(context);
      // Pop error
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Center(
              child: Text(
                "Password reset link sent! Check your email",
                style: TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (error) {
      // Pop the loading circle
      Navigator.pop(context);
      // Pop error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text(
                error.message.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palettes.backgroundColor1,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              // width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/forget_password.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Input Container
          Positioned(
            top: (MyUtility(context).height - inputContainerHeight) / 2,
            right: 30,
            left: 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: inputContainerWidth,
                  height: inputContainerHeight,
                  decoration: BoxDecoration(
                    color: Palettes.inputContainerColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Palettes.shadowColor.withOpacity(0.5),
                        blurRadius: 25,
                        spreadRadius: 10,
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Palettes.authIconColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Palettes.authIconColor.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'FORGET PASSWORD',
                                style: TextStyle(
                                  color: Palettes.textColor4,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          // Email TextFormField
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                            child: TextFormField(
                              controller: emailController,
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator,
                              style:
                                  const TextStyle(color: Palettes.textColor6),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  FlutterRemix.mail_settings_line,
                                  color: Palettes.authIconColor,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.textColor2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.authIconColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                contentPadding: EdgeInsets.all(10),
                                hintText: 'Enter email address',
                                hintStyle: TextStyle(
                                    fontSize: 18, color: Palettes.textColor2),
                              ),
                            ),
                          ),
                          // Submit Botton
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: TextButton(
                              onPressed: () => _submit(),
                              child: const Icon(
                                FlutterRemix.logout_circle_r_line,
                                color: Palettes.authIconColor,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Signin Instead
          Positioned(
            top: (MyUtility(context).height / 2) +
                (inputContainerHeight / 2) +
                100,
            left: 20,
            right: 20,
            child: Container(
              width: inputContainerWidth,
              decoration: const BoxDecoration(color: Palettes.backgroundColor1),
              child: const Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Palettes.textColor3,
                          thickness: 1.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Recover Password',
                          style: TextStyle(
                            fontSize: 20,
                            color: Palettes.textColor2,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Palettes.textColor3,
                          thickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
