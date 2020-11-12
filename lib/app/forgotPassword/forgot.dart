import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';

class GetPassword extends StatefulWidget {
  static final ROUTER = '/GetPassword?';
  @override
  _GetPasswordState createState() => _GetPasswordState();
}

class _GetPasswordState extends State<GetPassword> {

  String _email, _announce;
  bool _announceCheck = true;
  bool _checkEmail;


  Future<void> _check() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (_email == doc['email']){
          _checkEmail = true;
        }
      });
    });
    if(_checkEmail == true){
      FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Announce'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please check your email to get password')
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text('Approve'),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil( Login.ROUTER, (Route<dynamic> route) => false);
                  },
                ),
              ],
            );
          },
        );
      });
    } else {
      setState(() {
        _announceCheck = true;
        _announce = 'Wrong email';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Forgot password'
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Enter your email',
              ),
              TextField(
                onChanged: (text){
                  _email = text;
                },
                style: TextStyle(fontSize: 21),
                decoration: InputDecoration(
                    errorText: _announceCheck ? _announce : null,
                    contentPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(20)
                        )
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: _check,
                    child: Text(
                        'Get password'
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
