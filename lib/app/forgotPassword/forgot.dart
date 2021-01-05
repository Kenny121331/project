import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';

class GetPassword extends StatefulWidget {
  @override
  _GetPasswordState createState() => _GetPasswordState();
}

class _GetPasswordState extends State<GetPassword> {
  String _email, _announce;
  bool _announceCheck = true;
  bool _checkEmail;

  Future<void> _check() async {
    await users
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
        showDialogAnnounce(
            content: 'Please check your email to get password',
            onCancel: () => Get.offAllNamed(Routers.LOGIN)
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
