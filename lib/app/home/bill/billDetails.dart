
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/data/bill/BillJson.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class BillDetails extends StatelessWidget {
  String idBill;
  BillDetails({this.idBill});
  final CollectionReference bill = FirebaseFirestore.instance.collection('bill');
  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 21),
      ),
    );
  }

  Widget typeBill(int deposit, int price, int penalty, int timeUsed, int timeOverdue){
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
            text('Time Used: ${timeUsed ~/ 60} hours ${timeUsed % 60} minutes'),
            text('Money rent: $price k vnd'),
            text('Time Overdue: ${timeOverdue ~/ 60} hours ${timeOverdue % 60} minutes'),
            text('Money penalty: $penalty k vnd'),
            text('Total: ${price + penalty} k vnd')
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            text('Time Used: ${timeUsed ~/ 60} hours ${timeUsed % 60} minutes'),
            text('Money rent: $price k vnd'),
          ],
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bill details'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.event_note),
            onPressed: (){
              //Navigator.pushNamed(context, MyBills.ROUTER);
              Get.toNamed(Routers.MYBILLS);
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
                        typeBill(_bill.deposit, _bill.price, _bill.penalty, _bill.timeUsed, _bill.timeOverdue)
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
