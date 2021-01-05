import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/get.dart';


class ChangeEmail extends StatefulWidget {
  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  String _newEmail;
  String _errorTextEmail = 'The email address is badly formatted';
  bool _stateErrorEmail = false;
  _changeEmail() async {
    if (_newEmail == user.currentUser.email){
      _errorTextEmail = 'The new email is the same the old email';
      setState(() {
        _stateErrorEmail = true;
      });
    } else {
      user.currentUser.updateEmail(_newEmail).then((value){
        users
            .doc(user.currentUser.uid)
            .update({
          'email' : _newEmail
        }).then((value){
          showDialogAnnounce(
              content: 'Your email changed\n'
                  'Please log in again to use your account',
              onCancel: (){
                user.signOut().then((value){
                  Get.offAllNamed(Routers.LOGIN);
                });
              }
          );
        });
      }).catchError((onError){
        print('email Error');
        setState(() {
          _stateErrorEmail = true;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.currentUser.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(data['email'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text('If you want to change your email, please enter your new email below',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  TextField(
                    onChanged: (text){
                      _newEmail = text;
                    },
                    style: TextStyle(fontSize: 21),
                    decoration: InputDecoration(
                        errorText: _stateErrorEmail? _errorTextEmail : null,
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
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: (){
                        _changeEmail();
                      },
                      child: Text(
                          'change email'
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
