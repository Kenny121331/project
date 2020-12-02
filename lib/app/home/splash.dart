import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  static final ROUTER = '/SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration(seconds: 3),
            (){
          Navigator.pushReplacementNamed(context, Home.ROUTER);
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Image(
            image: AssetImage('assets/logo.jpg'),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        )
    );
  }
}