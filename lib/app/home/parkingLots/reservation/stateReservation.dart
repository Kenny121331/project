import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/reservationDetails.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyReservations extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'My reservation states'
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userState.where('idUser', isEqualTo: user.currentUser.uid)
            .where('stateRent', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              print(document.data().length);
              if (document.data().length > 0){
                var _userState = UserStateJson.fromJson(document.data());
                String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
                String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new GestureDetector(
                    onTap: (){
                      Get.to(ReservationDetails(
                        idUserState: _userState.idUserState,
                      ));
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                              width: 3,
                              color: _userState.notUsed== null ? Colors.green : Colors.red
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
              }else {
                return Center(
                  child: text('You do not have any reservations'),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
