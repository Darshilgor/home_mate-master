// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/config.dart';
import 'package:home_mate/constant/colors.dart';
import 'package:home_mate/screens/login.dart';
import 'package:home_mate/screens/provider/provider_sign_up.dart';
import 'package:home_mate/screens/sign_up.dart';
import 'package:home_mate/screens/welcome.dart';
import 'package:home_mate/widgets/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController!.forward();
    _animationController!.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await getUserDetails(user);
          if (type.isNotEmpty) {
            if (type == "provider") {
              print(providerUser.tagline);
              if (providerUser.tagline.isEmpty) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProviderSignUp()),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavBar(
                              index: 0,
                            )),
                    (route) => false);
              }
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavBar(
                            index: 0,
                          )),
                  (route) => false);
            }
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUp()));
          }
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              (route) => false);
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: Center(
            child: FadeTransition(
              opacity: _animationController!,
              child: child,
            ),
          ),
        );
      },
      child:
          const YourSplashScreenContent(), // Replace with your own splash screen content
    );
  }
}

class YourSplashScreenContent extends StatelessWidget {
  const YourSplashScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 120,
              width: 120,
              child: Image.asset('assets/images/logo.png')),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 65,
                  fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                    text: 'H',
                    style: TextStyle(color: clPrimary, fontSize: 80)),
                const TextSpan(text: 'ome '),
                TextSpan(
                    text: 'M',
                    style: TextStyle(color: clPrimary, fontSize: 80)),
                const TextSpan(text: 'ate '),
              ],
            ),
            textScaleFactor: 0.5,
          )
        ],
      ),
    );
  }
}
