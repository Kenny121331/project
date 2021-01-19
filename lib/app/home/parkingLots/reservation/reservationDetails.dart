import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/bill/billDetails.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/rentStateDetails.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/app/widget/common_widget.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLots.dart';
import 'package:flutter_app_parkinglots/data/firebase/data.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReservationDetails extends StatefulWidget {

  @override
  _ReservationDetailsState createState() => _ReservationDetailsState();
}

class _ReservationDetailsState extends State<ReservationDetails> {
  String idUserState;

  @override
  void initState() {
    idUserState = Get.arguments;
    super.initState();
  }

  _checkConditionCancel(){
    final DateTime _now = DateTime.now();
    userState
    .doc(idUserState)
        .get()
        .then((value){
       UserStateJson _userState = UserStateJson.fromJson(value.data());
       if (_now.isAfter(_userState.rentedTime.toDate().add(Duration(minutes: 10)))){
         showDialogAnnounce(
           content: 'Your reservation has been canceled. You have to pay a deposit',
           onCancel: () => _cancelPointWithDeposit()
         );
       } else {
         showDialogChoose(
             content: 'Are you sure to cancel this point?',
            textCancel: 'No',
            textConfirm: 'Yes',
            onConfirm: () => _cancelPoint()
         );
       }
    });
  }

  _cancelPoint() async {
    await userState
    .doc(idUserState)
        .delete().then((value) => Get.back());
    Get.offNamed(Routers.HOME);
  }

  _cancelPointWithDeposit() {
    userState
    .doc(idUserState)
        .get()
        .then((value) {
          final UserStateJson _userState = UserStateJson.fromJson(value.data());
          addParkingLots.exceptPointPL(_userState.idPL);
          bill.add({
            'nameUser' : _userState.nameUser,
            'idUser' : _userState.idUser,
            'namePL' : _userState.namePL,
            'addressPL' : _userState.addressPL,
            'idPL' : _userState.idPL,
            'rentedTime' : _userState.rentedTime,
            'returnTime' : _userState.returnTime,
            'phoneNumbersPL' : _userState.phoneNumbersPL,
            'deposit' : _userState.deposit,
          }).then((value2) async {
            await bill.doc(value2.id).update({
              'idBill' : value2.id
            });
            Get.back();
            await userState.doc(idUserState).delete().then((value3) => print('deleted'));
            Get.offNamed(
              Routers.BILLDETAILS,
              arguments: value2.id
            );
          });
    });
  }

  _rent(){
    final DateTime _now = DateTime.now();
    userState
        .doc(idUserState)
        .get()
        .then((value) async {
          final UserStateJson _userState = UserStateJson.fromJson(value.data());
      if (_checkRentalState(_userState.rentedTime, _now)){
        userState
            .doc(idUserState)
            .update({
          'stateRent' : true,
          'rentedTime' : _now
        }).then((value) async {
          await addParkingLots.addPointPL(_userState.idPL);
          Get.offNamed(
            Routers.MYRENTSTATESDETAILS,
            arguments: idUserState
          );
        });
      } else {
        if(_compareTime(_userState.rentedTime, _now)){
          showDialogAnnounce(
            content: 'You can\'t get this point too early'
          );
        } else {
          showDialogAnnounce(
            content: 'Your reservation has been canceled. You have to pay a deposit',
            onCancel: () => _cancelPointWithDeposit()
          );
        }
      }
    });
  }

  bool _checkRentalState(Timestamp rentedTime, DateTime now){
    if (now.isBefore(rentedTime.toDate().subtract(Duration(minutes: 10))) ||
        now.isAfter(rentedTime.toDate().add(Duration(minutes: 15)))){
      return false;
    } else {
      return true;
    }
  }

  bool _compareTime(Timestamp rentedTime, DateTime now){
    if (now.isBefore(rentedTime.toDate().subtract(Duration(minutes: 10)))){
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Booking details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              Get.toNamed(Routers.RESERVATION);
            },
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userState.doc(idUserState).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final UserStateJson _userState = UserStateJson.fromJson(snapshot.data.data());
            final String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
            final String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text('Name customer: ${_userState.nameUser}'),
                      text('Name parking lot: ${_userState.namePL}'),
                      text(_userState.addressPL),
                      text('Phone numbers of PL: ${_userState.phoneNumbersPL.toString()}'),
                      text('From: $_rentedTime'),
                      text('To: $_returnTime'),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              onPressed: _checkConditionCancel,
                              child: text('Cancel'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                color: Colors.green,
                                onPressed: (){
                                  _rent();
                                },
                                child: text('Rent'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
