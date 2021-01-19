import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/bill/BillJson.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MyBills extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'All bill'
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bill.where('idUser', isEqualTo: user.currentUser.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              if (document.data().length > 0){
                final BillJson _bill = BillJson.fromJson(document.data());
                final String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_bill.rentedTime.toDate());
                final String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_bill.returnTime.toDate());
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new GestureDetector(
                    onTap: (){
                      Get.toNamed(
                        Routers.BILLDETAILS,
                        arguments: _bill.idBill
                      );
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          border: Border.all(
                              width: 3,
                              color: Colors.green
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            text(_bill.namePL),
                            text('From: $_rentedTime'),
                            text('To: $_returnTime')
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: text('You don\'t have any bills'),
                );
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
