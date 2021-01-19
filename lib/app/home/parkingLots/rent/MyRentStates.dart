import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyRentStates extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'My rental states'
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userState.where('idUser', isEqualTo: user.currentUser.uid)
            .where('stateRent', isEqualTo: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              final UserStateJson _userState = UserStateJson.fromJson(document.data());
              final String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
              final String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new InkWell(
                  onTap: (){
                    Get.toNamed(
                      Routers.MYRENTSTATESDETAILS,
                      arguments: _userState.idUserState
                    );
                  },
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        border: Border.all(
                            width: 3,
                            color: _userState.notUsed ? Colors.red : Colors.green
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          text(_userState.namePL),
                          text('From: $_rentedTime'),
                          text('To: $_returnTime')
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
