import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/forgotPassword/forgot.dart';
import 'package:flutter_app_parkinglots/app/home/bill/bill.dart';
import 'package:flutter_app_parkinglots/app/home/home.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/allPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/MyRentStates.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/stateReservation.dart';
import 'package:flutter_app_parkinglots/app/home/splash.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';
import 'package:flutter_app_parkinglots/app/register/register.dart';

import 'home/parkingLots/pointDetails/allPoints.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Login.ROUTER: (context) => Login(),
        Register.ROUTER: (context) => Register(),
        Home.ROUTER: (context) => Home(),
        GetPassword.ROUTER: (context) => GetPassword(),
        SplashScreen.ROUTER: (context) => SplashScreen(),
        AllParkingLots.ROUTER: (context) => AllParkingLots(),
        ShowAllPoints.ROUTER: (context) => ShowAllPoints(),
        MyBills.ROUTER: (context) => MyBills(),
        MyReservations.ROUTER: (context) => MyReservations(),
        MyRentStates.ROUTER: (context) => MyRentStates()
      },
      home: Login(),
    );
  }
}
