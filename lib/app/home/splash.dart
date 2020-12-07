import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'home.dart';

class SplashScreen extends StatefulWidget {
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
          Get.off(Home());
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