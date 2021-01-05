import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/utils.dart';
import 'package:get/get.dart';

class ChangeInfor extends StatefulWidget {

  @override
  _ChangeInforState createState() => _ChangeInforState();
}

class _ChangeInforState extends State<ChangeInfor> {
  String _name, _phoneNumber, _licensePlate;
  Future<void> _changeInfor(String name, String phoneNumber, String licensePlate) async {
    users
        .doc(user.currentUser.uid)
        .update({
      'name' : _name?? name,
      'numberPhone' : _phoneNumber??phoneNumber,
      'licensePlate' : _licensePlate??licensePlate
    })
        .then((value){
          showDialogAnnounce(
            content: 'Changed successfully your information',
            onCancel: () => Get.toNamed(Routers.HOME)
          );
    })
        .catchError((error) => print("Failed to update user: $error"));
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
            print(data['numberPhone']);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Name'),
                      TextFormField(
                        initialValue: data['name'],
                        onChanged: (text){
                          _name = text;
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
                        child: Text('Your number phone'),
                      ),
                      TextFormField(
                        initialValue: data['numberPhone'],
                        onChanged: (text){
                          _phoneNumber = text;
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
                        child: Text('Your license plate'),
                      ),
                      TextFormField(
                        initialValue: data['licensePlate'],
                        onChanged: (text){
                          _licensePlate = text;
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
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, bottom: 80),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                color: Colors.green,
                                onPressed: (){
                                  _changeInfor(data['name'], data['numberPhone'] ,data['licensePlate']);
                                },
                                child: Text('Change'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        }
    );
  }
}
