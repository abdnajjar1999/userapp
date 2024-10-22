import 'package:durub/auth/register_screen.dart';
import 'package:durub/screens/home.dart';
import 'package:durub/widget/buildtextformfield.dart';
import 'package:durub/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginScreen extends StatefulWidget {
  static const screenRoute = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
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
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('User ID: ${userCredential.user!.uid}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Homescreen()),
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
                SizedBox(height: 10.h),
                Container(
                  height: 30.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/alilogo.png'),
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms).scale(),
                SizedBox(height: 4.h),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0),
                SizedBox(height: 1.h),
                Text(
                  'Sign in with your email & password',
                  style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),
                SizedBox(height: 5.h),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      AnimatedBuildTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        width: 90.w,
                        hintText: 'Email',
                        iconData: Icons.email_outlined,
                        label: 'Enter your email',
                        controller: emailController,
                      ),
                      SizedBox(height: 2.h),
                      AnimatedBuildTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        width: 90.w,
                        hintText: 'Password',
                        iconData: Icons.lock_outline,
                        label: 'Enter your password',
                        controller: passwordController,
                      ),
                      SizedBox(height: 4.h),
                      ButtonWidget(
                        width: 90.w,
                        callBack: _signInWithEmailAndPassword,
                        buttonText: 'Login',
                      ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black54, fontSize: 12.sp),
                    ),
                    TextButton(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
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
