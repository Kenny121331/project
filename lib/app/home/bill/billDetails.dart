
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/bill/bill.dart';
import 'package:flutter_app_parkinglots/data/bill/BillJson.dart';
import 'package:intl/intl.dart';

import '../home.dart';

class BillDetails extends StatelessWidget {
  String idBill;
  BillDetails({this.idBill});
  CollectionReference bill = FirebaseFirestore.instance.collection('bill');
  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 21),
      ),
    );
  }

  Widget typeBill(int deposit, int price, int penalty){
    if (deposit != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text('Note: You didn\'t rent this point'),
          text('Total payment amount: $deposit k vnd'),
        ],
      );
    } else {
      if (penalty != null){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text('Note: You have left the car overdue'),
            text('Money rent: $price k vnd'),
            text('Money penalty: $penalty k vnd'),
            text('Total: ${price + penalty} k vnd')
          ],
        );
      } else {
        return text('Total: $price k vnd');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: (){
            Navigator.of(context)
                .pushNamedAndRemoveUntil( Home.ROUTER, (Route<dynamic> route) => false);
          },
        ),
        title: Text(
          'Bill details'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.event_note),
            onPressed: (){
              Navigator.pushNamed(context, MyBills.ROUTER);
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: bill.doc(idBill).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              var _bill = BillJson.fromJson(snapshot.data.data());
              String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_bill.rentedTime.toDate());
              String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_bill.returnTime.toDate());
              //var _parkingLot = ParkingLotJson.fromJson(snapshot.data.data());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text('Name customer: ${_bill.nameUser}'),
                        text('Name parking lot: ${_bill.namePL}'),
                        text('Name point: ${_bill.namePoint}'),
                        text(_bill.addressPL),
                        text('Phone numbers of PL: ${_bill.phoneNumbersPL.toString()}'),
                        text('From: $_rentedTime'),
                        text('To: $_returnTime'),
                        typeBill(_bill.deposit, _bill.price, _bill.penalty)
                      ],
                    )
                  ],
                ),
              );
            }
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
      ),
    );
  }
}
