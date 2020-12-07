import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_parkinglots/app/home/bill/billDetails.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/rentStateDetails.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:flutter_app_parkinglots/data/addParkingLots/parkingLots.dart';
import 'package:flutter_app_parkinglots/data/stateUser/userStateJson.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';


class ReservationDetails extends StatefulWidget {
  String idUserState;
  ReservationDetails({this.idUserState});

  @override
  _ReservationDetailsState createState() => _ReservationDetailsState(
    idUserState: idUserState
  );
}

class _ReservationDetailsState extends State<ReservationDetails> {
  String idUserState;
  _ReservationDetailsState({this.idUserState});
  CollectionReference parkingLot = FirebaseFirestore.instance.collection('parkingLot');
  CollectionReference userState = FirebaseFirestore.instance.collection('userState');
  CollectionReference point = FirebaseFirestore.instance.collection('point');
  CollectionReference bill = FirebaseFirestore.instance.collection('bill');
  var addParkingLots = AddParkingLots();
  final DateTime _now = DateTime.now();
  Widget text(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 21),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  _checkConditionCancel(){
    userState
    .doc(idUserState)
        .get()
        .then((value){
       UserStateJson _userState = UserStateJson.fromJson(value.data());
       if (_now.isAfter(_userState.rentedTime.toDate().add(Duration(minutes: 10)))){
         _announce('Your reservation has been canceled. You have to pay a deposit', (){
           _cancelPointWithDeposit();
         });
       } else {
         _chooseCancelPoint();
       }
    });
  }
  Future<void> _chooseCancelPoint() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to cancel this point?'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.green,
              child: Text('No'),
              onPressed: () {
                //Navigator.of(context).pop();
                Get.back();
              },
            ),
            RaisedButton(
              color: Colors.green,
              child: Text('Yes'),
              onPressed: () {
                _cancelPoint();
              },
            ),
          ],
        );
      },
    );
  }
  _cancelPoint() async {
    await userState
    .doc(idUserState)
        .delete();
    // await Navigator.pop(context);
    // Navigator.pushReplacementNamed(context, Home.ROUTER);
    await Get.back();
    Get.offNamed(Routers.HOME);
  }
  _cancelPointWithDeposit() {
    userState
    .doc(idUserState)
        .get()
        .then((value) async {
          var _userState = UserStateJson.fromJson(value.data());
         await point.doc(_userState.idPoint).delete().then((value) => print('deleted point'));
          bill.add({
            'nameUser' : _userState.nameUser,
            'idUser' : _userState.idUser,
            'namePL' : _userState.namePL,
            'addressPL' : _userState.addressPL,
            'idPL' : _userState.idPL,
            'namePoint' : _userState.namePoint,
            'rentedTime' : _userState.rentedTime,
            'returnTime' : _userState.returnTime,
            'phoneNumbersPL' : _userState.phoneNumbersPL,
            'deposit' : _userState.deposit,
          }).then((value2) async {
            await bill.doc(value2.id).update({
              'idBill' : value2.id
            });
            await userState.doc(idUserState).delete().then((value3) => print('deleted'));
            // await Navigator.pop(context);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BillDetails(
            //   idBill: value2.id,
            // )));
            await Get.back();
            Get.off(BillDetails(idBill: value2.id));
          });
    });
  }
  _rent(){
    userState
        .doc(idUserState)
        .get()
        .then((value) async {
          var _userState = UserStateJson.fromJson(value.data());
      if (_checkRentalState(_userState.rentedTime)){
        await addParkingLots.changePoint(_userState.idPL, _userState.namePoint, true);
        userState
            .doc(idUserState)
            .update({
          'stateRent' : true,
          'timeGetPoint' : _now
        }).then((value) async {
          await Get.back();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => RentStateDetails(
          //       idUserState: idUserState,
          //     )));

        });
      } else {
        if(_compareTime(_userState.rentedTime)){
          _announce('You can\'t get this point too early', (){
            print('true - true');

            //Navigator.of(context).pop();
            Get.back();
          });
        } else {
          _announce('Your reservation has been canceled. You have to pay a deposit', (){
            _cancelPointWithDeposit();
          });
        }
      }
    });
  }
  bool _checkRentalState(Timestamp rentedTime){
    if (_now.isBefore(rentedTime.toDate().subtract(Duration(minutes: 10))) ||
        _now.isAfter(rentedTime.toDate().add(Duration(minutes: 15)))){
      return false;
    } else {
      return true;
    }
  }
  bool _compareTime(Timestamp rentedTime){
    if (_now.isBefore(rentedTime.toDate().subtract(Duration(minutes: 10)))){
      return true;
    } else {
      return false;
    }
  }
  Future<void> _announce(String text, Function function) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Announce'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Yes'),
              onPressed: function,
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              //Navigator.pushNamed(context, MyReservations.ROUTER);
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
            var _userState = UserStateJson.fromJson(snapshot.data.data());
            String _rentedTime = DateFormat('kk:mm  dd-MM-yyyy').format(_userState.rentedTime.toDate());
            String _returnTime= DateFormat('kk:mm  dd-MM-yyyy').format(_userState.returnTime.toDate());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      text('Name customer: ${_userState.nameUser}'),
                      text('Name parking lot: ${_userState.namePL}'),
                      text('Name point: ${_userState.namePoint}'),
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
