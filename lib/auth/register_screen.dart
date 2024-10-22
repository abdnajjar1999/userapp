import 'package:durub/screens/complite_profile.dart';
import 'package:durub/widget/buildtextformfield.dart';
import 'package:durub/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordController1;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordController1 = TextEditingController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordController1.dispose();
    super.dispose();
  }

  Future<void> _createAccountWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('User ID: ${userCredential.user!.uid}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => CompleteProfileScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                SizedBox(height: 5.h),
                Container(
                  height: 20.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/alilogo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms).scale(),
                SizedBox(height: 3.h),
                Text(
                  'Sign up Account',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                SizedBox(height: 1.h),
                Text(
                  'Join us and experience fast reliable delivery',
                  style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
                SizedBox(height: 4.h),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      AnimatedBuildTextFormField(
                        width: 90.w,
                        hintText: 'Email',
                        label: 'Enter your email',
                        iconData: Icons.email_outlined,
                        controller: emailController,
                      ),
                      SizedBox(height: 2.h),
                      AnimatedBuildTextFormField(
                        width: 90.w,
                        label: 'Password',
                        iconData: Icons.lock_outline,
                        hintText: 'Enter your Password',
                        controller: passwordController,
                      ),
                      SizedBox(height: 2.h),
                      AnimatedBuildTextFormField(
                        width: 90.w,
                        label: 'Confirm password',
                        iconData: Icons.lock_outline,
                        hintText: 'Re-Enter your Password',
                        controller: passwordController1,
                      ),
                      SizedBox(height: 4.h),
                      ButtonWidget(
                        width: 90.w,
                        callBack: () {
                          if (passwordController.text == passwordController1.text) {
                            _createAccountWithEmailAndPassword(
                              emailController.text,
                              passwordController.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Password and confirm password do not match'),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.all(10),
                              ),
                            );
                          }
                        },
                        buttonText: 'Sign up',
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                    ),
                    TextButton(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ).animate().fadeIn(delay: 1000.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
