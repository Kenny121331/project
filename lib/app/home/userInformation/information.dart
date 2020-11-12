import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/userInformation/password/password.dart';
import 'package:flutter_app_parkinglots/app/home/userInformation/privateInfor/privateInfor.dart';

import 'email/email.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  int _selectedIndex = 0;
  String name = 'Information';

  static List<Widget> _WIDGET_OPTION = <Widget>[
    ChangeInfor(),
    ChangePassword(),
    ChangeEmail(),
  ];
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
      if (index == 0){
        name = 'Information';
      } else if (index == 1) {
        name = 'Change password';
      } else if (index == 2) {
        name = 'Change Email';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(name),
      ),
      body: _WIDGET_OPTION.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Information')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_outline),
              title: Text('Password')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.email),
              title: Text('Email')
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
