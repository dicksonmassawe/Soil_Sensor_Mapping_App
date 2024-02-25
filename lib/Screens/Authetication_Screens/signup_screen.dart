import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sensor_mapping/Constants/color_palettes.dart';
import 'package:sensor_mapping/Constants/my_utility.dart';
import 'package:sensor_mapping/Constants/validate_credential.dart';
import 'package:sensor_mapping/Screens/Authetication_Screens/auth_screen.dart';
import 'package:sensor_mapping/Screens/Authetication_Screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Bool values
  bool _obscureText = true;

  // Input Container dimensions
  double inputContainerHeight = 350;
  double inputContainerWidth = 350;

  //Icon size
  double iconSize = 60;

  //Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController comfirmPasswordController = TextEditingController();

  //Credential Validator
  String? emailValidator(String? value) {
    return EmailValidator.validateEmail(value);
  }

  String? passwordValidator(String? value) {
    return PasswordValidator.validatePassword(value);
  }

  String? comfirmPasswordValidator(String? value) {
    return PasswordValidator.validatePassword(value);
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

    try {
      if (passwordController.text == comfirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        // Pop the loading circle
        Navigator.pop(context);
        // Return to AuthPage for going to splash screen
        Navigator.of(context).push(PageTransition(
          type: PageTransitionType.fade,
          child: const AuthPage(),
          duration: Duration(milliseconds: transitionTime),
          reverseDuration: Duration(milliseconds: transitionTime),
        ));
      } else {
        // Pop the loading circle
        Navigator.pop(context);
        // Show error message of password mismatch
        showErrorMessage('Password mismatch');
      }
    } on FirebaseAuthException catch (error) {
      // Pop the loading circle
      Navigator.pop(context);
      // Show error message
      showErrorMessage(error.code);
    }
  }

  // Pop Error
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              message,
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
        );
      },
    );
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
                  image: AssetImage('images/signup.jpeg'),
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
                                'SIGN-UP',
                                style: TextStyle(
                                  color: Palettes.textColor4,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          // Email TextFormField
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
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
                                  FlutterRemix.mail_add_line,
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
                          // Password TextFormField
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              validator: passwordValidator,
                              style:
                                  const TextStyle(color: Palettes.textColor6),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_open,
                                  color: Palettes.authIconColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Palettes.authIconColor,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    setState(
                                      () {
                                        _obscureText = !_obscureText;
                                      },
                                    );
                                  },
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.textColor2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.authIconColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                                hintText: 'Enter password',
                                hintStyle: const TextStyle(
                                    fontSize: 18, color: Palettes.textColor2),
                              ),
                            ),
                          ),
                          // Comfirm password TextFormField
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                            child: TextFormField(
                              controller: comfirmPasswordController,
                              obscureText: _obscureText,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              validator: comfirmPasswordValidator,
                              style:
                                  const TextStyle(color: Palettes.textColor6),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.lock_open,
                                  color: Palettes.authIconColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Palettes.authIconColor,
                                  ),
                                  onPressed: () {
                                    // Toggle the visibility of the password
                                    setState(
                                      () {
                                        _obscureText = !_obscureText;
                                      },
                                    );
                                  },
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.textColor2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Palettes.authIconColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(35.0)),
                                ),
                                contentPadding: const EdgeInsets.all(10),
                                hintText: 'Re-enter password',
                                hintStyle: const TextStyle(
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
                20,
            left: 20,
            right: 20,
            child: Container(
              width: inputContainerWidth,
              decoration: const BoxDecoration(color: Palettes.backgroundColor1),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeftJoined,
                        childCurrent: widget,
                        child: const LoginScreen(),
                        duration: Duration(milliseconds: transitionTime),
                        reverseDuration: Duration(milliseconds: transitionTime),
                      ));
                    },
                    child: const Text(
                      'SignIn Instead',
                      style: TextStyle(
                        color: Palettes.textColor3,
                        fontStyle: FontStyle.italic,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Row(
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
                          'or SignUp with',
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
                  const SizedBox(
                    height: 20,
                  ),
                  // Bottom Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Apple Signin Button
                      TextButton(
                        onPressed: () {},
                        child: Icon(
                          FlutterRemix.apple_fill,
                          size: iconSize,
                          color: Colors.black,
                        ),
                      ),
                      // Google Signin Button
                      TextButton(
                        onPressed: () {},
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const SweepGradient(
                              colors: [
                                Color(0xFF4285F4), // Google Blue
                                Color(0xFF34A853), // Google Green
                                Color(0xFFFBBC05), // Google Yellow
                                Color(0xFFEA4335), // Google Red
                                Color(0xFF4285F4), // Google Blue
                              ],
                              startAngle: 0,
                              endAngle: 2 * 3.14,
                            ).createShader(bounds);
                          },
                          child: Icon(
                            FlutterRemix.google_fill,
                            size: iconSize,
                            color: Colors
                                .white, // You can set any color here, as it will be masked by the gradient
                          ),
                        ),
                      ),
                      // Github Signin Button
                      TextButton(
                        onPressed: () {},
                        child: Icon(
                          FlutterRemix.github_fill,
                          size: iconSize,
                          color: Colors.black,
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
