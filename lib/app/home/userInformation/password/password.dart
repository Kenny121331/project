import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';
import 'package:get/get.dart';


class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FirebaseAuth user = FirebaseAuth.instance;
  String _oldPassword, _newPassword, _newPasswordCheck;
  String _errorTextPassword, _errorTextNewPassword;
  bool _stateErrorPassword = false;
  bool _stateErrorNewPassword = false;
  Future<void> _changePassword() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.currentUser.email)
        .where('password', isEqualTo: _oldPassword)
        .get();
    if(result.docs.length == null) {
      _errorTextPassword = 'Old password incorrect';
      setState(() {
        _stateErrorPassword = true;
        _stateErrorNewPassword = false;
      });
    } else {
      if(_newPassword != _newPasswordCheck){
        _errorTextNewPassword = 'New password incorrect';
        setState(() {
          _stateErrorPassword = false;
          _stateErrorNewPassword = true;
        });
      } else {
        _changePasswordReal();
      }
    }
  }
  void _changePasswordReal() async{
    User user = await FirebaseAuth.instance.currentUser;
    user.updatePassword(_newPassword).then((_){
      print("Succesfull changed password");
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'password' : _newPassword
      }).then((value){
        return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Your information changed'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please log in again to use your account')
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text('Approve'),
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value){
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil( Login.ROUTER, (Route<dynamic> route) => false);
                      Get.offAll(Login());
                    });
                  },
                ),
              ],
            );
          },
        );
      })
      ;
    }).catchError((onError){
      _errorTextNewPassword = 'Your new pass word too week';
      setState(() {
        _stateErrorNewPassword = true;
        _stateErrorPassword = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    'Enter your old password'
                ),
                TextField(
                  obscureText: true,
                  onChanged: (text){
                    _oldPassword = text;
                  },
                  style: TextStyle(fontSize: 21),
                  decoration: InputDecoration(
                      errorText: _stateErrorPassword? _errorTextPassword : null,
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
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'Enter your new password'
                  ),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (text){
                    _newPassword = text;
                  },
                  style: TextStyle(fontSize: 21),
                  decoration: InputDecoration(
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
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      'Enter your new password again'
                  ),
                ),
                TextField(
                  obscureText: true,
                  onChanged: (text){
                    _newPasswordCheck = text;
                  },
                  style: TextStyle(fontSize: 21),
                  decoration: InputDecoration(
                      errorText: _stateErrorNewPassword ? _errorTextNewPassword : null,
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
                      onPressed: _changePassword,
                      child: Text('Change'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}