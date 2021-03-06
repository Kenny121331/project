import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/bill/BillJson.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BillDetails extends StatefulWidget {

  @override
  _BillDetailsState createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  String idBill;

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
  void initState() {
    idBill = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Bill details'
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.event_note),
            onPressed: (){
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
              final String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_bill.rentedTime.toDate());
              final String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_bill.returnTime.toDate());
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        text('Name customer: ${_bill.nameUser}'),
                        text('Name parking lot: ${_bill.namePL}'),
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
