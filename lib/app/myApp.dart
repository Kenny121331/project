import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_pages.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth user = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      enableLog: true,
      initialRoute: user.currentUser.uid != null ?
        '/login' : AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
