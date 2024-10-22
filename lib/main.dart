import 'dart:async';
import 'package:durub/auth/login_screen.dart';
import 'package:durub/firebase_options.dart'; // Ensure this import is correct
import 'package:durub/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if a user is already logged in
  User? user = FirebaseAuth.instance.currentUser;
  Widget initialRoute;

  if (user != null) {
    // User is logged in, go to the home screen
    initialRoute = Homescreen();
  } else {
    // User is not logged in, go to the splash screen
    initialRoute = SplashScreen();
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final Widget initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lock orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Your App Title',
          theme: ThemeData.light(),
          initialRoute: '/',
          routes: {
            '/': (context) => initialRoute, // Decide the initial route based on login status
            '/login': (context) => LoginScreen(),
            '/home': (context) => Homescreen(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Start the animations
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Scale animation for the pulsing effect
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Opacity animation for the blurring and clearing screen effect
    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to LoginScreen if the user is not logged in, or to Homescreen if logged in
    Timer(const Duration(seconds: 4), () {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // User is logged in, go to the home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Homescreen()),
        );
      } else {
        // No user is logged in, go to the login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Blurred screen effect using AnimatedOpacity
              Opacity(
                opacity: _opacityAnimation.value,
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 100.w, // Responsive width for the logo
                      height: 100.w, // Responsive height for the logo
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          image: AssetImage('assets/logo.png'), // Ensure this path is correct
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Pulsing logo effect
              Positioned(
                bottom: 10.h, // Positioning the text at the bottom
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Made By Zero one Technology',
                    style: TextStyle(
                      fontSize: 15.sp, // Responsive font size
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
